#!/usr/bin/ruby

require 'xcodeproj'

# Usage:
# ruby select_xcode_signing_method.rb -p <path/to/xcode_project> -t <Target> -m ['Automatic' | 'Manual']

class Options
  attr_accessor :path, :target, :method, :build_number, :plist_location

  def initialize(args)
    @path           = args[:path] || Dir.glob("*.xcodeproj").first
    @target         = args[:target]
    @method         = args[:method]
    @build_number   = args[:build_number]
    @plist_location = args[:plist_location]
  end
end

def parse_args
  options_hash = {}
  args         = ARGV
  args.each_with_index do |arg, index|
    case arg
    when '--project_path', '-p'
      path = args[index + 1]
      unless File.exist?(path)
        abort('There is no file at specified path.')
      end
      options_hash[:path] = path
    when '--build_number', '-b'
      options_hash[:build_number] = args[index + 1]
    when '--target', '-t'
      options_hash[:target] = args[index + 1]
    when '--plist-location', '-i'
      path = args[index + 1]
      unless File.exist?(path)
        abort('There is no file at specified path.')
      end
      options_hash[:plist_location] = path
    when '--signing_method', '-m'
      method = args[index + 1]
      unless ['Automatic', 'Manual'].include?(method)
        abort("'Invalid signing method specified. Please use either 'Automatic' or 'Manual'")
      end
      options_hash[:method] = method
    end
  end

  options_hash
end

options = Options.new parse_args

project = Xcodeproj::Project.open(options.path)

target_id                                          = project.targets.select { |target| target.name == options.target }.first.uuid
project.root_object.attributes['TargetAttributes'] = { target_id => { "ProvisioningStyle" => "Automatic" } } unless project.root_object.attributes.nil?
attributes                                         = project.root_object.attributes['TargetAttributes']
target_attributes                                  = attributes[target_id]
target_attributes['ProvisioningStyle']             = options.method

project.save

puts "Code signing was set to '#{options.method}'."

plist                                  = Xcodeproj::Plist.read_from_path(options.plist_location)
plist['CFBundleVersion']               = options.build_number
plist['ITSAppUsesNonExemptEncryption'] = false unless plist['ITSAppUsesNonExemptEncryption']
Xcodeproj::Plist.write_to_path(plist, options.plist_location)
