# -*- encoding: utf-8 -*-
require 'rubygems'
require 'rake'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rspec'
require 'rspec/core'
require 'rspec/core/rake_task'

$:.unshift  File.join(File.dirname(__FILE__), "lib")

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec)

def clean_up
  Dir.glob("*.gem").each { |f| File.unlink(f) }
  Dir.glob("*.lock").each { |f| File.unlink(f) }  
end

desc "Build the gem"
task :build do
  puts `gem build c7decrypt.gemspec`
end

desc "Publish the gem"
task :publish do
  Dir.glob("*.gem").each { |f| puts `gem push #{f}`} 
end

desc "Perform an end-to-end release of the gem"
task :release do
  clean_up() # Clean up before we start
  Rake::Task[:build].execute
  Rake::Task[:publish].execute
  clean_up() # Clean up after we complete
end
