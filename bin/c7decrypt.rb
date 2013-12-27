require '../lib/c7decrypt'
require 'optparse'
require 'ostruct'

options = OpenStruct.new
options.string = nil
options.file = nil

OptionParser.new do |opts|
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
end.parse!

if options.string
  puts C7Decrypt.decrypt(options.string)  
end

if options.file &&
   File.exists?(options.file)

  C7Decrypt.decrypt_config(options.file).each {|pw| puts pw }
end
