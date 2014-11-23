require 'c7decrypt'
require 'rspec/its'

describe C7Decrypt::Type5 do

  context "when encrypting single Cisco Type-5 hash" do 
    before(:each) do
      @password = "SECRETPASSWORD"
      @salt = "TMnL"
      @hash = C7Decrypt::Type5.encrypt(@password, @salt)
    end
  
    subject{@hash}
    its(:class) {should == ::String}
    it {should == "$1$TMnL$iAFs16ZXx7x18vR1DeIp6/"}
  end

end
