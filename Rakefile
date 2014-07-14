# -*- encoding: utf-8 -*-
require 'rubygems'
require 'rake'
require 'rubygems/package_task'
require 'rspec'
require 'rspec/core'
require 'rspec/core/rake_task'

$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'c7decrypt'

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec)

def clean_up
  Dir.glob("*.gem").each { |f| File.unlink(f) }
  Dir.glob("*.lock").each { |f| File.unlink(f) }  
end

desc "Fuzz C7Decrypt"
task :fuzz do
  puts "[+] Fuzzing C7Decrypt"
  puts `mkdir bugs` unless File.directory?("bugs")
  puts `fuzzbert --bug-dir bugs --limit 10000000 "fuzz/fuzz_**.rb"`
end

desc "Build the gem"
task :build do
  puts "[+] Building C7Decrypt version #{C7Decrypt::VERSION}"
  puts `gem build c7decrypt.gemspec`
end

desc "Publish the gem"
task :publish do
  puts "[+] Publishing C7Decrypt version #{C7Decrypt::VERSION}"  
  Dir.glob("*.gem").each { |f| puts `gem push #{f}`} 
end

desc "Tag the release"
task :tag do
  puts "[+] Tagging C7Decrypt version #{C7Decrypt::VERSION}"  
  `git tag #{C7Decrypt::VERSION}`
  `git push --tags`
end

desc "Bump the Gemspec Version"
task :bump do
  puts "[+] Bumping C7Decrypt version #{C7Decrypt::VERSION}"
  `git commit -a -m "Bumped Gem version to #{C7Decrypt::VERSION}"`
  `git push origin master`
end

desc "Perform an end-to-end release of the gem"
task :release do
  clean_up() # Clean up before we start
  Rake::Task[:build].execute
  Rake::Task[:bump].execute
  Rake::Task[:tag].execute
  Rake::Task[:publish].execute
  clean_up() # Clean up after we complete
end
