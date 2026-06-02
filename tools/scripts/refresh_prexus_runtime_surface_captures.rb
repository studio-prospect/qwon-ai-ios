#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'optparse'
require 'pathname'
require 'tmpdir'

DEVICE_CONFIGS = {
  'iphone16' => {
    destination: "platform=iOS Simulator,name=iPhone 16,OS=18.4"
  },
  'iphonese3' => {
    destination: "platform=iOS Simulator,name=iPhone SE (3rd generation),OS=18.2"
  }
}.freeze

options = {
  devices: [],
  output_root: Pathname('docs/design/runtime-surface-captures'),
  project: Pathname('app/ios/PREXUS.xcodeproj'),
  scheme: 'QWON'
}

OptionParser.new do |parser|
  parser.banner = 'Usage: refresh_prexus_runtime_surface_captures.rb [--device SLUG] [--all]'

  parser.on('--device SLUG', "Device slug to refresh (#{DEVICE_CONFIGS.keys.join(', ')})") do |value|
    options[:devices] << value
  end

  parser.on('--all', 'Refresh captures for every supported device slug') do
    options[:devices] = DEVICE_CONFIGS.keys.dup
  end

  parser.on('--output-root DIR', 'Directory that contains per-device capture folders') do |value|
    options[:output_root] = Pathname(value)
  end

  parser.on('--project PATH', 'Path to the Xcode project') do |value|
    options[:project] = Pathname(value)
  end

  parser.on('--scheme NAME', 'Xcode scheme name') do |value|
    options[:scheme] = value
  end

  parser.on('--help', 'Show this help message') do
    puts parser
    exit 0
  end
end.parse!

devices = options[:devices].uniq
devices = ['iphone16'] if devices.empty?

invalid_devices = devices - DEVICE_CONFIGS.keys
unless invalid_devices.empty?
  abort("error: unsupported device slug(s): #{invalid_devices.join(', ')}")
end

project_path = options[:project].expand_path
output_root = options[:output_root].expand_path
export_script = Pathname(__dir__).join('export_prexus_xcuitest_screenshots.rb').expand_path

abort("error: project not found: #{project_path}") unless project_path.exist?
abort("error: export script not found: #{export_script}") unless export_script.exist?

def run_command!(command)
  puts ">> #{command.join(' ')}"
  success = system(*command)
  return if success

  status = $?.exitstatus || 'unknown'
  abort("error: command failed with status #{status}: #{command.join(' ')}")
end

devices.each do |device_slug|
  config = DEVICE_CONFIGS.fetch(device_slug)
  capture_dir = output_root.join(device_slug)
  FileUtils.mkdir_p(capture_dir)

  Dir.mktmpdir("prexus-runtime-captures-#{device_slug}-") do |temp_dir|
    result_bundle = Pathname(temp_dir).join("QWON-#{device_slug}.xcresult")

    run_command!([
      'xcodebuild',
      '-project', project_path.to_s,
      '-scheme', options[:scheme],
      '-destination', config.fetch(:destination),
      '-only-testing:QWONUITests',
      '-resultBundlePath', result_bundle.to_s,
      'test'
    ])

    run_command!([
      'ruby',
      export_script.to_s,
      '--xcresult', result_bundle.to_s,
      '--output-dir', capture_dir.to_s
    ])
  end
end
