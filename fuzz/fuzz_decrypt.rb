require 'fuzzbert'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'c7decrypt'

fuzz "C7Decrypt.decrypt" do
  deploy do |data|
    begin
      C7Decrypt.decrypt(data)
    rescue StandardError
      #fine, we just want to capture crashes
    end
  end

  data "completely random" do
    FuzzBert::Generators.random
  end
end