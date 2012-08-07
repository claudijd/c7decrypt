# This is a ruby script to emulate the functionality originally seen in 
#  cdecrypt.pl (See README.md)
#
# Author: Jonathan Claudius (@claudijd)
#
# Usage: ruby ./bin/cdecrypt.rb <cisco_type_7_hash|cisco_config_file>

require '../lib/c7decrypt'

#Throw Usage Info
def usage 
  puts "Usage: ruby ./bin/cdecrypt.rb <cisco_type_7_hash|cisco_config_file>"
  puts "Example #1: ruby ./bin/cdecrypt.rb 04480E051A33490E"
  puts "Example #2: ruby ./bin/cdecrypt.rb ./spec/example_configs/simple_canned_example.txt"
end

#Make sure we only get one argument
if !ARGV.size == 1
  usage()
  exit
end

#Get a instance of C7Decrypt to use
c7d = C7Decrypt.new()

#Check to see if the arg is file, if so, process it, 
# if not, treat it as a single hash
if File.exists?(ARGV[0])
  c7d.decrypt_config(ARGV[0]).each do |pw|
    puts pw
  end
else
  puts c7d.decrypt(ARGV[0])
end
