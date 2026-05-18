#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'optparse'
require 'open3'
require 'pathname'
require 'time'
require 'tmpdir'

options = {
  output_dir: nil,
  xcresult: nil
}

OptionParser.new do |parser|
  parser.banner = 'Usage: export_prexus_xcuitest_screenshots.rb --xcresult PATH --output-dir DIR'

  parser.on('--xcresult PATH', 'Path to the .xcresult bundle to export from') do |value|
    options[:xcresult] = value
  end

  parser.on('--output-dir DIR', 'Directory to receive deterministic screenshot files') do |value|
    options[:output_dir] = value
  end

  parser.on('--help', 'Show this help message') do
    puts parser
    exit 0
  end
end.parse!

abort('error: --xcresult is required') if options[:xcresult].to_s.empty?
abort('error: --output-dir is required') if options[:output_dir].to_s.empty?

xcresult_path = Pathname(options[:xcresult]).expand_path
output_dir = Pathname(options[:output_dir]).expand_path

abort("error: xcresult bundle not found: #{xcresult_path}") unless xcresult_path.exist?

FileUtils.mkdir_p(output_dir)

def command_failed!(command, status, stderr)
  abort <<~MSG
    error: command failed with status #{status.exitstatus}
    command: #{command.join(' ')}
    #{stderr}
  MSG
end

def normalized_file_name(suggested_name)
  file_name = File.basename(suggested_name)
  extension = File.extname(file_name)
  stem = File.basename(file_name, extension)

  normalized_stem = stem.sub(/_\d+_[0-9A-F\-]{36}\z/i, '')
  "#{normalized_stem}#{extension}"
end

Dir.mktmpdir('prexus-xcresult-export') do |temp_dir|
  command = [
    'xcrun', 'xcresulttool', 'export', 'attachments',
    '--path', xcresult_path.to_s,
    '--output-path', temp_dir
  ]

  stdout, stderr, status = Open3.capture3(*command)
  command_failed!(command, status, stderr) unless status.success?

  manifest_path = File.join(temp_dir, 'manifest.json')
  abort("error: manifest not produced: #{manifest_path}") unless File.exist?(manifest_path)

  manifest = JSON.parse(File.read(manifest_path))
  exported = []

  manifest.each do |test_entry|
    attachments = test_entry.fetch('attachments', [])

    attachments.each do |attachment|
      source_name = attachment.fetch('exportedFileName')
      suggested_name = attachment.fetch('suggestedHumanReadableName', source_name)
      source_path = File.join(temp_dir, source_name)
      next unless File.exist?(source_path)

      destination_name = normalized_file_name(suggested_name)
      destination_path = output_dir.join(destination_name)

      FileUtils.cp(source_path, destination_path)

      exported << {
        'testIdentifier' => test_entry['testIdentifier'],
        'deviceName' => attachment['deviceName'],
        'sourceFileName' => source_name,
        'exportedFileName' => destination_name,
        'timestamp' => attachment['timestamp']
      }
    end
  end

  metadata = {
    'sourceXCResult' => xcresult_path.to_s,
    'exportedAt' => Time.now.iso8601,
    'attachments' => exported.sort_by { |entry| entry['exportedFileName'] }
  }

  File.write(output_dir.join('manifest.json'), JSON.pretty_generate(metadata) + "\n")
  puts stdout unless stdout.empty?
  puts "Exported #{exported.count} PREXUS screenshot attachment(s) to #{output_dir}"
end
