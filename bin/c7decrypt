#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'c7decrypt'

options = OpenStruct.new
options.string = nil
options.file = nil

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: cdecrypt.rb [options] [hash/file]"

  opts.on("-s", "--string [HASH]", "A single encrypted hash string") do |v|
    options.string = v
  end

  opts.on("-f", "--file [FILE]", "A file containing multiple hashes") do |v|
    options.file = v
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts ""
    puts opts
    puts ""
    puts "Example: ruby cdecrypt.rb -s 04480E051A33490E"
    puts "Example: ruby cdecrypt.rb -f ../spec/example_configs/simple_canned_example.txt"
    puts ""
    exit
  end
end

opt_parser.parse!

if options.string.nil? &&
   options.file.nil?

  puts ""
  puts opt_parser
  puts ""
  puts "Example: ruby cdecrypt.rb -s 04480E051A33490E"
  puts "Example: ruby cdecrypt.rb -f ../spec/example_configs/simple_canned_example.txt"
  puts ""
  exit
end

if options.string
  puts C7Decrypt.decrypt(options.string)  
end

if options.file &&
   File.exists?(options.file)

  C7Decrypt.decrypt_config(options.file).each {|pw| puts pw }
end
