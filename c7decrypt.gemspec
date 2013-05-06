require 'c7decrypt/version'

Gem::Specification.new do |s|
  s.name = 'c7decrypt'
  s.version = C7Decrypt::Version
  s.authors = ["Jonathan Claudius"]
  s.date = Date.today.to_s 
  s.email = 'claudijd@yahoo.com'
  s.platform = Gem::Platform::RUBY
  s.files = ["lib/c7decrypt.rb"]
  s.require_paths = ["lib"]
  s.summary = 'Ruby based Cisco Type 7 Password Decryptor'
  s.description = 'A library for decoding Cisco Type 7 passwords'  
  s.homepage = 'http://rubygems.org/gems/c7decrypt'
end
