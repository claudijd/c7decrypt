# -*- encoding: utf-8 -*-
require 'rubygems'
require 'rake'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rspec/core'
require 'rspec/core/rake_task'

$:.unshift  File.join(File.dirname(__FILE__), "lib")

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec)

desc 'Generate documentation for c7decrypt.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'c7decrypt'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/*.rb')
end


spec = Gem::Specification.new do |s|
  s.name = %q{c7decrypt}
  s.version = '1.0'
  s.authors = ["Jon Claudius"]
  s.date = %q{2012-09-07}
  s.email = %q{jclaudius@trustwave.com}
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = Dir["**/*"] - Dir["*.gem"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.files = FileList["{bin,lib}/*"].to_a
  s.require_paths = ["lib"]
  s.summary = %q{Ruby based Cisco Type 7 Password Decryptor}
end
 
desc "Build gem file"
Gem::PackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
  pkg.need_zip = true
end
