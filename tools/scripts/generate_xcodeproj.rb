require "pathname"
require "xcodeproj"

ROOT = Pathname.new(__dir__).join("..", "..").expand_path
IOS_ROOT = ROOT.join("app", "ios")
PROJECT_PATH = IOS_ROOT.join("PREXUS.xcodeproj")

app_sources = Dir.glob(IOS_ROOT.join("PREXUS", "**", "*.swift").to_s)
runtime_sources = Dir.glob(ROOT.join("runtime", "**", "*.swift").to_s)
test_sources = Dir.glob(IOS_ROOT.join("PREXUSTests", "**", "*.swift").to_s)
resources = Dir.glob(IOS_ROOT.join("PREXUS", "Resources", "**", "*").to_s).reject do |path|
  File.directory?(path) || File.basename(path) == "Info.plist"
end
shared_resources = Dir.glob(IOS_ROOT.join("shared", "**", "*").to_s).reject { |path| File.directory?(path) }

project = Xcodeproj::Project.new(PROJECT_PATH.to_s)
project.root_object.attributes["LastSwiftUpdateCheck"] = "1600"
project.root_object.attributes["LastUpgradeCheck"] = "1600"

app_target = project.new_target(:application, "PREXUS", :ios, "17.0")
test_target = project.new_target(:unit_test_bundle, "PREXUSTests", :ios, "17.0")
test_target.add_dependency(app_target)

app_target.product_reference.name = "PREXUS.app"
test_target.product_reference.name = "PREXUSTests.xctest"

main_group = project.main_group
app_group = main_group.new_group("PREXUS", "PREXUS")
runtime_group = main_group.new_group("runtime", "../../runtime")
shared_group = main_group.new_group("shared", "../shared")
tests_group = main_group.new_group("PREXUSTests", "PREXUSTests")

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

test_sources.each do |path|
  add_file(test_target, tests_group, path, IOS_ROOT.join("PREXUSTests"))
end

resources_group = app_group["Resources"] || app_group.new_group("Resources", "Resources")
resources.each do |path|
  group = ensure_groups(resources_group, path, IOS_ROOT.join("PREXUS", "Resources"))
  file_ref = group.new_file(File.basename(path))
  app_target.resources_build_phase.add_file_reference(file_ref, true)
end

shared_resources.each do |path|
  group = ensure_groups(shared_group, path, IOS_ROOT.join("shared"))
  file_ref = group.new_file(File.basename(path))
  app_target.resources_build_phase.add_file_reference(file_ref, true)
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
  config.build_settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = ""
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

project.save
