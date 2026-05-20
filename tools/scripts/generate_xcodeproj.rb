require "pathname"
require "rexml/document"
require "rexml/xpath"
require "xcodeproj"

ROOT = Pathname.new(__dir__).join("..", "..").expand_path
IOS_ROOT = ROOT.join("app", "ios")
PROJECT_PATH = IOS_ROOT.join("PREXUS.xcodeproj")
SCHEME_PATH = PROJECT_PATH.join("xcshareddata", "xcschemes", "PREXUS.xcscheme")

app_sources = Dir.glob(IOS_ROOT.join("PREXUS", "**", "*.swift").to_s)
runtime_sources = Dir.glob(ROOT.join("runtime", "**", "*.swift").to_s)
test_sources = Dir.glob(IOS_ROOT.join("PREXUSTests", "**", "*.swift").to_s)
ui_test_sources = Dir.glob(IOS_ROOT.join("PREXUSUITests", "**", "*.swift").to_s)
resource_root = IOS_ROOT.join("PREXUS", "Resources")
asset_catalogs = Dir.glob(resource_root.join("**", "*.xcassets").to_s)
resources = Dir.glob(resource_root.join("**", "*").to_s).reject do |path|
  File.basename(path) == "Info.plist" ||
    File.directory?(path) ||
    asset_catalogs.any? { |catalog| path.start_with?("#{catalog}/") }
end
shared_resources = Dir.glob(IOS_ROOT.join("shared", "**", "*").to_s).reject { |path| File.directory?(path) }
bridge_sources = Dir.glob(IOS_ROOT.join("PREXUS", "LlamaCppBridge", "*.{mm,h}").to_s)
llama_xcframework = ROOT.join("vendor", "llama-cpp-artifacts", "llama.xcframework")
llama_available = llama_xcframework.exist?
bridging_header = IOS_ROOT.join("PREXUS", "LlamaCppBridge", "PREXUS-Bridging-Header.h")

project = Xcodeproj::Project.new(PROJECT_PATH.to_s)
project.root_object.attributes["LastSwiftUpdateCheck"] = "1600"
project.root_object.attributes["LastUpgradeCheck"] = "1600"

app_target = project.new_target(:application, "PREXUS", :ios, "17.0")
test_target = project.new_target(:unit_test_bundle, "PREXUSTests", :ios, "17.0")
ui_test_target = project.new_target(:ui_test_bundle, "PREXUSUITests", :ios, "17.0")
test_target.add_dependency(app_target)
ui_test_target.add_dependency(app_target)

app_target.product_reference.name = "PREXUS.app"
test_target.product_reference.name = "PREXUSTests.xctest"
ui_test_target.product_reference.name = "PREXUSUITests.xctest"

main_group = project.main_group
app_group = main_group.new_group("PREXUS", "PREXUS")
runtime_group = main_group.new_group("runtime", "../../runtime")
shared_group = main_group.new_group("shared", "../shared")
tests_group = main_group.new_group("PREXUSTests", "PREXUSTests")
ui_tests_group = main_group.new_group("PREXUSUITests", "PREXUSUITests")

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
  add_file(app_target, app_group, path, IOS_ROOT.join("PREXUS"))
end

runtime_sources.each do |path|
  add_file(app_target, runtime_group, path, ROOT.join("runtime"))
end

bridge_sources.each do |path|
  add_file(app_target, app_group, path, IOS_ROOT.join("PREXUS"))
end

test_sources.each do |path|
  add_file(test_target, tests_group, path, IOS_ROOT.join("PREXUSTests"))
end

ui_test_sources.each do |path|
  add_file(ui_test_target, ui_tests_group, path, IOS_ROOT.join("PREXUSUITests"))
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
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.prexus.ios"
  config.build_settings["INFOPLIST_FILE"] = "PREXUS/Resources/Info.plist"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
  config.build_settings["DEVELOPMENT_TEAM"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
  config.build_settings["SWIFT_EMIT_LOC_STRINGS"] = "NO"
  config.build_settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"
  config.build_settings["CLANG_CXX_LANGUAGE_STANDARD"] = "gnu++17"
  config.build_settings["SWIFT_OBJC_BRIDGING_HEADER"] = "PREXUS/LlamaCppBridge/PREXUS-Bridging-Header.h"
  config.build_settings["OTHER_LDFLAGS"] = ["$(inherited)", "-lc++"]

  next unless llama_available

  config.build_settings["FRAMEWORK_SEARCH_PATHS"] = [
    "$(inherited)",
    llama_xcframework.dirname.to_s
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
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.prexus.ios.tests"
  config.build_settings["INFOPLIST_FILE"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["TEST_HOST"] = "$(BUILT_PRODUCTS_DIR)/PREXUS.app/PREXUS"
  config.build_settings["BUNDLE_LOADER"] = "$(TEST_HOST)"
end

ui_test_target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.prexus.ios.uitests"
  config.build_settings["INFOPLIST_FILE"] = ""
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1"
  config.build_settings["TEST_TARGET_NAME"] = "PREXUS"
  config.build_settings["CLANG_ENABLE_OBJC_WEAK"] = "NO"
end

project.save

if SCHEME_PATH.exist?
  scheme = REXML::Document.new(SCHEME_PATH.read)
  targets_by_name = {
    app_target.name => app_target,
    test_target.name => test_target,
    ui_test_target.name => ui_test_target
  }

  REXML::XPath.each(scheme, "//BuildableReference") do |reference|
    target = targets_by_name[reference.attributes["BlueprintName"]]
    next unless target

    reference.attributes["BlueprintIdentifier"] = target.uuid
    reference.attributes["BuildableName"] = target.product_reference.path || target.product_reference.name
  end

  formatter = REXML::Formatters::Pretty.new(3)
  formatter.compact = true
  output = +""
  formatter.write(scheme, output)
  output << "\n"
  SCHEME_PATH.write(output)
end
