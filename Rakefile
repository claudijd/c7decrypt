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
