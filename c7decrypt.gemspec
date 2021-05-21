$: << "lib"
require 'c7decrypt/version'

Gem::Specification.new do |s|
  s.name = 'c7decrypt'
  s.version = C7Decrypt::VERSION
  s.authors = ["Jonathan Claudius"]
  s.email = 'claudijd@yahoo.com'
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("lib/**/*") +
            Dir.glob("bin/**/*") +
            [".gitignore",
             ".rspec",
             ".travis.yml",
             "CONTRIBUTING.md",
             "Gemfile",
             "LICENSE",
             "README.md",
             "Rakefile",
             "c7decrypt.gemspec"]
  s.license       = "ruby"
  s.require_paths = ["lib"]
  s.executables   = s.files.grep(%r{^bin/[^\/]+$}) { |f| File.basename(f) }
  s.summary = 'Ruby based Cisco Password Encryptor/Decryptor'
  s.description = 'A library for encrypting/decrypting Cisco passwords'
  s.homepage = 'http://rubygems.org/gems/c7decrypt'
  s.cert_chain  = ['certs/claudijd.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  s.add_development_dependency('fuzzbert', '~> 1.0')
  s.add_development_dependency('rspec', '~> 3.0')
  s.add_development_dependency('rspec-its', '~> 1.2')
  s.add_development_dependency "rake", ">= 12.3.3"
  s.add_development_dependency('coveralls')
end
