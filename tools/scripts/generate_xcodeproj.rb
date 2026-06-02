require "pathname"
require "xcodeproj"

# Regenerates app/ios/PREXUS.xcodeproj (container name deferred in Phase 4).
# Active app target/scheme/module: QWON. Test targets: QWONTests / QWONUITests.
# Links llama.xcframework only when vendor/llama-cpp-artifacts/llama.xcframework exists.
# Commit the output from a machine without that artifact so clean checkouts can run QWONTests.
#
# Optional LiteRT-LM evaluation target (isolated app, does not link into QWON):
#   PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb
#
# Optional LiteRT-LM debug prototype inside QWON (compile-gated, off by default):
#   PREXUS_LITERT_LM_PROTOTYPE=1 ruby tools/scripts/generate_xcodeproj.rb

ROOT = Pathname.new(__dir__).join("..", "..").expand_path
MAIN_BUNDLE_ID = "jp.studio-prospect.qwon.ios"
TEST_BUNDLE_ID = "#{MAIN_BUNDLE_ID}.tests"
UI_TEST_BUNDLE_ID = "#{MAIN_BUNDLE_ID}.uitests"
LITERT_EVAL_BUNDLE_ID = "#{MAIN_BUNDLE_ID}.literteval"
IOS_ROOT = ROOT.join("app", "ios")
APP_SOURCE_DIR = "QWON"
UNIT_TEST_TARGET = "QWONTests"
UI_TEST_TARGET = "QWONUITests"
PROJECT_PATH = IOS_ROOT.join("PREXUS.xcodeproj")
APP_TARGET_NAME = "QWON"
LEGACY_APP_SCHEME = "PREXUS"
SCHEME_PATH = PROJECT_PATH.join("xcshareddata", "xcschemes", "#{APP_TARGET_NAME}.xcscheme")
LEGACY_SCHEME_PATH = PROJECT_PATH.join("xcshareddata", "xcschemes", "#{LEGACY_APP_SCHEME}.xcscheme")

litert_prototype_only_source_names = %w[
  LiteRTLocalModelClient.swift
  LocalBackendComparisonRunner.swift
  LocalStrictJSONBenchmarkRunner.swift
].freeze

app_sources = Dir.glob(IOS_ROOT.join(APP_SOURCE_DIR, "**", "*.swift").to_s).reject do |path|
  litert_prototype_only_source_names.include?(File.basename(path))
end
runtime_sources = Dir.glob(ROOT.join("runtime", "**", "*.swift").to_s)
test_sources = Dir.glob(IOS_ROOT.join(UNIT_TEST_TARGET, "**", "*.swift").to_s)
ui_test_sources = Dir.glob(IOS_ROOT.join(UI_TEST_TARGET, "**", "*.swift").to_s)
resource_root = IOS_ROOT.join(APP_SOURCE_DIR, "Resources")
asset_catalogs = Dir.glob(resource_root.join("**", "*.xcassets").to_s)
resources = Dir.glob(resource_root.join("**", "*").to_s).reject do |path|
  File.basename(path) == "Info.plist" ||
    File.directory?(path) ||
    asset_catalogs.any? { |catalog| path.start_with?("#{catalog}/") }
end
shared_resources = Dir.glob(IOS_ROOT.join("shared", "**", "*").to_s).reject { |path| File.directory?(path) }
bridge_sources = Dir.glob(IOS_ROOT.join(APP_SOURCE_DIR, "LlamaCppBridge", "*.{mm,h}").to_s)
llama_xcframework = ROOT.join("vendor", "llama-cpp-artifacts", "llama.xcframework")
llama_available = llama_xcframework.exist?
bridging_header = IOS_ROOT.join(APP_SOURCE_DIR, "LlamaCppBridge", "QWON-Bridging-Header.h")

project = Xcodeproj::Project.new(PROJECT_PATH.to_s)
project.root_object.attributes["LastSwiftUpdateCheck"] = "1600"
project.root_object.attributes["LastUpgradeCheck"] = "1600"

app_target = project.new_target(:application, APP_TARGET_NAME, :ios, "17.0")
test_target = project.new_target(:unit_test_bundle, UNIT_TEST_TARGET, :ios, "17.0")
ui_test_target = project.new_target(:ui_test_bundle, UI_TEST_TARGET, :ios, "17.0")
test_target.add_dependency(app_target)
ui_test_target.add_dependency(app_target)

app_target.product_reference.name = "#{APP_TARGET_NAME}.app"
test_target.product_reference.name = "#{UNIT_TEST_TARGET}.xctest"
ui_test_target.product_reference.name = "#{UI_TEST_TARGET}.xctest"

main_group = project.main_group
app_group = main_group.new_group(APP_SOURCE_DIR, APP_SOURCE_DIR)
runtime_group = main_group.new_group("runtime", "../../runtime")
shared_group = main_group.new_group("shared", "../shared")
tests_group = main_group.new_group(UNIT_TEST_TARGET, UNIT_TEST_TARGET)
ui_tests_group = main_group.new_group(UI_TEST_TARGET, UI_TEST_TARGET)

def ensure_groups(parent_group, absolute_path, root_path)
  relative = Pathname.new(absolute_path).relative_path_from(root_path).to_s
  dirname = File.dirname(relative)
  return parent_group if dirname == "."

  dirname.split("/").reduce(parent_group) do |group, component|
    group[component] || group.new_group(component, component)
  end
end

def add_file(target, parent_group, absolute_path, root_path)
  group = ensure_groups(parent_group, absolute_path, root_path)
  file_ref = group.new_file(File.basename(absolute_path))
  target.add_file_references([file_ref])
end

app_sources.each do |path|
  add_file(app_target, app_group, path, IOS_ROOT.join(APP_SOURCE_DIR))
end

runtime_sources.each do |path|
  add_file(app_target, runtime_group, path, ROOT.join("runtime"))
end

bridge_sources.each do |path|
  add_file(app_target, app_group, path, IOS_ROOT.join(APP_SOURCE_DIR))
end

test_sources.each do |path|
  add_file(test_target, tests_group, path, IOS_ROOT.join(UNIT_TEST_TARGET))
end

ui_test_sources.each do |path|
  add_file(ui_test_target, ui_tests_group, path, IOS_ROOT.join(UI_TEST_TARGET))
end

resources_group = app_group["Resources"] || app_group.new_group("Resources", "Resources")
asset_catalogs.each do |path|
  group = ensure_groups(resources_group, path, resource_root)
  file_ref = group.new_file(File.basename(path))
  file_ref.last_known_file_type = "folder.assetcatalog"
  app_target.resources_build_phase.add_file_reference(file_ref, true)
end

resources.each do |path|
  group = ensure_groups(resources_group, path, resource_root)
  file_ref = group.new_file(File.basename(path))
  app_target.resources_build_phase.add_file_reference(file_ref, true)
end

shared_resources.each do |path|
  group = ensure_groups(shared_group, path, IOS_ROOT.join("shared"))
  file_ref = group.new_file(File.basename(path))
  app_target.resources_build_phase.add_file_reference(file_ref, true)
end

if llama_available
  framework_ref = project.frameworks_group.new_file(llama_xcframework.to_s)
  framework_ref.last_known_file_type = "wrapper.xcframework"
  app_target.frameworks_build_phase.add_file_reference(framework_ref)

  embed_frameworks_phase = app_target.copy_files_build_phases.find { |phase| phase.name == "Embed Frameworks" }
  unless embed_frameworks_phase
    embed_frameworks_phase = app_target.new_copy_files_build_phase("Embed Frameworks")
    embed_frameworks_phase.symbol_dst_subfolder_spec = :frameworks
  end
  embed_build_file = embed_frameworks_phase.add_file_reference(framework_ref)
  embed_build_file.settings = { "ATTRIBUTES" => %w[CodeSignOnCopy RemoveHeadersOnCopy] }
end

app_target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = MAIN_BUNDLE_ID
  config.build_settings["INFOPLIST_FILE"] = "#{APP_SOURCE_DIR}/Resources/Info.plist"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
  config.build_settings["DEVELOPMENT_TEAM"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
  config.build_settings["SWIFT_EMIT_LOC_STRINGS"] = "NO"
  config.build_settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"
  config.build_settings["CLANG_CXX_LANGUAGE_STANDARD"] = "gnu++17"
  config.build_settings["SWIFT_OBJC_BRIDGING_HEADER"] = "#{APP_SOURCE_DIR}/LlamaCppBridge/QWON-Bridging-Header.h"
  config.build_settings["OTHER_LDFLAGS"] = ["$(inherited)", "-lc++"]

  next unless llama_available

  config.build_settings["FRAMEWORK_SEARCH_PATHS"] = [
    "$(inherited)",
    "$(SRCROOT)/../../vendor/llama-cpp-artifacts"
  ]
  config.build_settings["OTHER_LDFLAGS"] << "-framework" << "llama"
  config.build_settings["GCC_PREPROCESSOR_DEFINITIONS"] = [
    "$(inherited)",
    "PREXUS_LLAMA_CPP_AVAILABLE=1"
  ]
  config.build_settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = [
    "$(inherited)",
    "PREXUS_LLAMA_CPP_AVAILABLE"
  ]
end

test_target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = TEST_BUNDLE_ID
  config.build_settings["INFOPLIST_FILE"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["TEST_HOST"] = "$(BUILT_PRODUCTS_DIR)/#{APP_TARGET_NAME}.app/#{APP_TARGET_NAME}"
  config.build_settings["BUNDLE_LOADER"] = "$(TEST_HOST)"
end

ui_test_target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = UI_TEST_BUNDLE_ID
  config.build_settings["INFOPLIST_FILE"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["TEST_TARGET_NAME"] = APP_TARGET_NAME
  config.build_settings["CLANG_ENABLE_OBJC_WEAK"] = "NO"
end

litert_eval_target = nil
if ENV["PREXUS_LITERT_LM_EVAL"] == "1"
  litert_sources = Dir.glob(IOS_ROOT.join("PREXUSLiteRTEval", "**", "*.swift").to_s)
  litert_eval_target = project.new_target(:application, "PREXUSLiteRTEval", :ios, "17.0")
  litert_eval_target.product_reference.name = "PREXUSLiteRTEval.app"
  litert_group = main_group.new_group("PREXUSLiteRTEval", "PREXUSLiteRTEval")

  litert_sources.each do |path|
    add_file(litert_eval_target, litert_group, path, IOS_ROOT.join("PREXUSLiteRTEval"))
  end

  litert_vendor = ROOT.join("vendor", "LiteRT-LM")
  if litert_vendor.join("Package.swift").exist?
    package_ref = project.new(Xcodeproj::Project::Object::XCLocalSwiftPackageReference)
    package_ref.relative_path = "../../vendor/LiteRT-LM"
    puts "Using local LiteRT-LM package at vendor/LiteRT-LM"
  else
    package_ref = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
    package_ref.repositoryURL = "https://github.com/google-ai-edge/LiteRT-LM"
    package_ref.requirement = {
      "kind" => "upToNextMajorVersion",
      "minimumVersion" => "0.12.0"
    }
    puts "Using remote LiteRT-LM package (run ./tools/scripts/vendor_litert_lm.sh if SPM LFS checkout fails)"
  end
  project.root_object.package_references << package_ref

  package_product = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
  package_product.product_name = "LiteRTLM"
  package_product.package = package_ref
  litert_eval_target.package_product_dependencies << package_product

  litert_eval_target.build_configurations.each do |config|
    config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = LITERT_EVAL_BUNDLE_ID
    config.build_settings["INFOPLIST_FILE"] = "PREXUSLiteRTEval/Resources/Info.plist"
    config.build_settings["SWIFT_VERSION"] = "5.0"
    config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
    config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
    config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
    config.build_settings["DEVELOPMENT_TEAM"] = ""
    config.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
    config.build_settings["SWIFT_EMIT_LOC_STRINGS"] = "NO"
    config.build_settings["OTHER_LDFLAGS"] = ["$(inherited)"]
  end

  litert_scheme_path = PROJECT_PATH.join("xcshareddata", "xcschemes", "PREXUSLiteRTEval.xcscheme")
  litert_scheme_path.parent.mkpath
  litert_scheme_path.write(<<~XML)
    <?xml version="1.0" encoding="UTF-8"?>
    <Scheme LastUpgradeVersion="1600" version="1.7">
       <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
          <BuildActionEntries>
             <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">
                <BuildableReference
                   BuildableIdentifier="primary"
                   BlueprintIdentifier="#{litert_eval_target.uuid}"
                   BuildableName="PREXUSLiteRTEval.app"
                   BlueprintName="PREXUSLiteRTEval"
                   ReferencedContainer="container:PREXUS.xcodeproj">
                </BuildableReference>
             </BuildActionEntry>
          </BuildActionEntries>
       </BuildAction>
       <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="YES">
          <BuildableProductRunnable runnableDebuggingMode="0">
             <BuildableReference
                BuildableIdentifier="primary"
                BlueprintIdentifier="#{litert_eval_target.uuid}"
                BuildableName="PREXUSLiteRTEval.app"
                BlueprintName="PREXUSLiteRTEval"
                ReferencedContainer="container:PREXUS.xcodeproj">
             </BuildableReference>
          </BuildableProductRunnable>
       </LaunchAction>
    </Scheme>
  XML

  puts "Added PREXUSLiteRTEval target + LiteRT-LM Swift package (evaluation only)."
end

if ENV["PREXUS_LITERT_LM_PROTOTYPE"] == "1"
  litert_prototype_sources = [
    IOS_ROOT.join(APP_SOURCE_DIR, "LocalInference", "LiteRTLocalModelClient.swift").to_s,
    IOS_ROOT.join(APP_SOURCE_DIR, "LocalInference", "LocalBackendComparisonRunner.swift").to_s,
    IOS_ROOT.join(APP_SOURCE_DIR, "LocalInference", "LocalStrictJSONBenchmarkRunner.swift").to_s
  ]

  litert_prototype_sources.each do |path|
    next unless File.file?(path)
    add_file(app_target, app_group, path, IOS_ROOT.join(APP_SOURCE_DIR))
  end

  litert_vendor = ROOT.join("vendor", "LiteRT-LM")
  package_ref = if litert_vendor.join("Package.swift").exist?
    ref = project.new(Xcodeproj::Project::Object::XCLocalSwiftPackageReference)
    ref.relative_path = "../../vendor/LiteRT-LM"
    puts "Using local LiteRT-LM package for QWON prototype at vendor/LiteRT-LM"
    ref
  else
    ref = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
    ref.repositoryURL = "https://github.com/google-ai-edge/LiteRT-LM"
    ref.requirement = {
      "kind" => "upToNextMajorVersion",
      "minimumVersion" => "0.12.0"
    }
    puts "Using remote LiteRT-LM package for QWON prototype (run ./tools/scripts/vendor_litert_lm.sh if needed)"
    ref
  end
  project.root_object.package_references << package_ref unless project.root_object.package_references.any? { |existing|
    existing.is_a?(Xcodeproj::Project::Object::XCLocalSwiftPackageReference) && existing.relative_path == "../../vendor/LiteRT-LM" ||
      existing.is_a?(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference) && existing.repositoryURL == "https://github.com/google-ai-edge/LiteRT-LM"
  }

  package_product = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
  package_product.product_name = "LiteRTLM"
  package_product.package = package_ref
  app_target.package_product_dependencies << package_product

  app_target.build_configurations.each do |config|
    conditions = Array(config.build_settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] || ["$(inherited)"])
    conditions << "PREXUS_LITERT_LM_PROTOTYPE" unless conditions.include?("PREXUS_LITERT_LM_PROTOTYPE")
    config.build_settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = conditions
  end

  puts "Linked LiteRT-LM Swift package into QWON (PREXUS_LITERT_LM_PROTOTYPE)."
end

project.save

scheme_path = SCHEME_PATH
scheme_path.parent.mkpath
scheme_xml = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <Scheme LastUpgradeVersion="1600" version="1.7">
     <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
        <BuildActionEntries>
           <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">
              <BuildableReference
                 BuildableIdentifier="primary"
                 BlueprintIdentifier="#{app_target.uuid}"
                 BuildableName="#{APP_TARGET_NAME}.app"
                 BlueprintName="#{APP_TARGET_NAME}"
                 ReferencedContainer="container:PREXUS.xcodeproj">
              </BuildableReference>
           </BuildActionEntry>
        </BuildActionEntries>
     </BuildAction>
     <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.DebuggerFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES">
        <Testables>
           <TestableReference skipped="NO" parallelizable="YES">
              <BuildableReference
                 BuildableIdentifier="primary"
                 BlueprintIdentifier="#{test_target.uuid}"
                 BuildableName="#{UNIT_TEST_TARGET}.xctest"
                 BlueprintName="#{UNIT_TEST_TARGET}"
                 ReferencedContainer="container:PREXUS.xcodeproj">
              </BuildableReference>
           </TestableReference>
           <TestableReference skipped="NO" parallelizable="NO">
              <BuildableReference
                 BuildableIdentifier="primary"
                 BlueprintIdentifier="#{ui_test_target.uuid}"
                 BuildableName="#{UI_TEST_TARGET}.xctest"
                 BlueprintName="#{UI_TEST_TARGET}"
                 ReferencedContainer="container:PREXUS.xcodeproj">
              </BuildableReference>
           </TestableReference>
        </Testables>
        <MacroExpansion>
           <BuildableReference
              BuildableIdentifier="primary"
              BlueprintIdentifier="#{app_target.uuid}"
              BuildableName="#{APP_TARGET_NAME}.app"
              BlueprintName="#{APP_TARGET_NAME}"
              ReferencedContainer="container:PREXUS.xcodeproj">
           </BuildableReference>
        </MacroExpansion>
     </TestAction>
     <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="YES">
        <BuildableProductRunnable runnableDebuggingMode="0">
           <BuildableReference
              BuildableIdentifier="primary"
              BlueprintIdentifier="#{app_target.uuid}"
              BuildableName="#{APP_TARGET_NAME}.app"
              BlueprintName="#{APP_TARGET_NAME}"
              ReferencedContainer="container:PREXUS.xcodeproj">
           </BuildableReference>
        </BuildableProductRunnable>
     </LaunchAction>
     <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES">
        <BuildableProductRunnable runnableDebuggingMode="0">
           <BuildableReference
              BuildableIdentifier="primary"
              BlueprintIdentifier="#{app_target.uuid}"
              BuildableName="#{APP_TARGET_NAME}.app"
              BlueprintName="#{APP_TARGET_NAME}"
              ReferencedContainer="container:PREXUS.xcodeproj">
           </BuildableReference>
        </BuildableProductRunnable>
     </ProfileAction>
     <AnalyzeAction buildConfiguration="Debug"> </AnalyzeAction>
     <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"> </ArchiveAction>
  </Scheme>
XML
scheme_path.write(scheme_xml)
LEGACY_SCHEME_PATH.delete if LEGACY_SCHEME_PATH.exist?
