puts "test"

require 'c7decrypt'

describe C7Decrypt do

  before(:each) do
    @c7d = C7Decrypt.new()
    @known_values = [
      {:pt => "cisco", :seed => 2, :ph => "02050D480809"},
      {:pt => "cisco", :seed => 3, :ph => "030752180500"},
      {:pt => "cisco", :seed => 4, :ph => "045802150C2E"},
      {:pt => "cisco", :seed => 5, :ph => "05080F1C2243"}, 
      {:pt => "cisco", :seed => 6, :ph => "060506324F41"},
      {:pt => "cisco", :seed => 7, :ph => "070C285F4D06"},
      {:pt => "cisco", :seed => 8, :ph => "0822455D0A16"},         
      {:pt => "cisco", :seed => 9, :ph => "094F471A1A0A"},
      {:pt => "password", :seed => 9, :ph => "095C4F1A0A1218000F"},
      {:pt => "password", :seed => 4, :ph => "044B0A151C36435C0D"}
    ]
  end

  context "when initializing the class" do 
    subject{@c7d}
    its(:class) {should == C7Decrypt}
  end

  context "when decrypting single Cisco Type-7 hash using longhand" do 
    before(:each) do
      @encrypted_hash = "060506324F41"
      @decrypted_hash = @c7d.decrypt(@encrypted_hash)
    end
  
    subject{@decrypted_hash}
    its(:class) {should == ::String}
    it {should == "cisco"}
  end

  context "when decrypting single Cisco Type-7 hash using shorthand" do 
    before(:each) do
      @encrypted_hash = "060506324F41"
      @decrypted_hash = @c7d.d(@encrypted_hash)
    end
  
    subject{@decrypted_hash}
    its(:class) {should == ::String}
    it {should == "cisco"}
  end

  context "when decrypting an array of Cisco Type-7 hashes using longhand" do 
    before(:each) do
      @encrypted_hashes = [
        "060506324F41",
        "0822455D0A16"
      ]
      @decrypted_hashes = @c7d.decrypt_array(@encrypted_hashes)
    end
  
    subject{@decrypted_hashes}
    its(:class) {should == ::Array}
    its(:first) {should == "cisco"}
    its(:last) {should == "cisco"}
    its(:size) {should == 2}
  end

  context "when decrypting an array of Cisco Type-7 hashes using shorthand" do 
    before(:each) do
      @encrypted_hashes = [
        "060506324F41",
        "0822455D0A16"
      ]
      @decrypted_hashes = @c7d.d_a(@encrypted_hashes)
    end

    subject{@decrypted_hashes}
    its(:class) {should == ::Array}
    its(:first) {should == "cisco"}
    its(:last) {should == "cisco"}
    its(:size) {should == 2}
  end

  context "when decrypting Cisco Type-7 hashes from a config using longhand" do 
    before(:each) do
      @config_file = "./spec/example_configs/simple_canned_example.txt"
      @decrypted_hashes = @c7d.decrypt_config(@config_file)
    end
  
    subject{@decrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == 5}
    it {should == [
      "cisco",
      "cisco",
      "cisco",
      "cisco",
      "cisco"
    ]}
  end

  context "when decrypting Cisco Type-7 hashes from a config using shorthand" do 
    before(:each) do
      @config_file = "./spec/example_configs/simple_canned_example.txt"
      @decrypted_hashes = @c7d.d_c(@config_file)
    end
  
    subject{@decrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == 5}
    it {should == [
      "cisco",
      "cisco",
      "cisco",
      "cisco",
      "cisco"
    ]}
  end

  context "when decrypting known Cisco Type-7 known value matches" do 
    before(:each) do
      @decrypted_hashes = @c7d.decrypt_array(
                            @known_values.map {|known_value| known_value[:ph]}
                          )
    end

    subject{@decrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == @known_values.size}
    it {should == @known_values.map {|known_value| known_value[:pt]}}
  end

  context "when decrypting Cisco Type-7 with a seed greater than 9" do 
    before(:each) do
      @decrypt_hash = @c7d.decrypt("15000E010723382727")
    end

    subject{@decrypt_hash}
    its(:class) {should == ::String}
    it {should == "remcisco"}
  end

  context "when matchings known Cisco Type-7 known config line matches" do 
    before(:each) do
      @encrypted_hashes = []
      @known_config_lines = {
        "username test password 7 0822455D0A16" => "0822455D0A16",
        "enable password 7 060506324F41" => "060506324F41",
        "password 7 02050D480809" => "02050D480809"
      }

      @known_config_lines.keys.each do |k,v|
        @encrypted_hashes << @c7d.type_7_matches(k)
      end
      @encrypted_hashes.flatten!
    end

    subject{@encrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == @known_config_lines.size}
    it {should == @known_config_lines.values}
  end

  context "when encrypting single Cisco Type-7 hash using longhand" do 
    before(:each) do
      @plaintext_hash = "cisco"
      @encrypted_hash = @c7d.encrypt(@plaintext_hash)
    end

    subject{@encrypted_hash}
    its(:class) {should == ::String}
    it {should == "02050D480809"}
  end

  context "when encrypting single Cisco Type-7 hash with an alternate seed value" do 
    before(:each) do
      @plaintext_hash = "cisco"
      @seed = 3
      @encrypted_hash = @c7d.encrypt(@plaintext_hash, @seed)
    end

    subject{@encrypted_hash}
    its(:class) {should == ::String}
    it {should == "030752180500"}

    it "should decrypt back to the original plaintext hash" do
      @c7d.decrypt(@encrypted_hash).should == @plaintext_hash
    end
  end

  context "when encrypting multiple plaintext passwords with alternate seed values" do 
    before(:each) do
      @plaintext_hash = "cisco"
      @seeds = 0..9
      @encrypted_hashes = @seeds.map {|seed| @c7d.encrypt(@plaintext_hash, seed)}
    end

    subject{@encrypted_hashes}
    its(:class) {should == ::Array}

    it "should decrypt back to the original plaintext hashes" do
      @encrypted_hashes.each do |encrypted_hash|
        @c7d.decrypt(encrypted_hash).should == @plaintext_hash
      end
    end
  end

  context "when encrypting known value matches individually" do 
    before(:each) do
      @encrypted_hashes = []
      @known_values.each do |known_value|
        @encrypted_hashes << @c7d.encrypt(known_value[:pt], known_value[:seed])
      end
    end

    subject{@encrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == @known_values.size}
    it {should == @known_values.map {|known_value| known_value[:ph]}}
  end

  context "when encrypting known value matches individually using short hand" do 
    before(:each) do
      @encrypted_hashes = []
      @known_values.each do |known_value|
        @encrypted_hashes << @c7d.e(known_value[:pt], known_value[:seed])
      end
    end

    subject{@encrypted_hashes}
    its(:class) {should == ::Array}
    its(:size) {should == @known_values.size}
    it {should == @known_values.map {|known_value| known_value[:ph]}}
  end

  context "when encrypting known value matches individually as an array" do 
    before(:each) do
      @plaintext_passwords = @known_values.map {|known_value| known_value[:pt]}.uniq
      @encrypted_passwords = @c7d.encrypt_array(@plaintext_passwords)
    end

    subject{@encrypted_passwords}
    its(:class) {should == ::Array}
    its(:size) {should == @plaintext_passwords.size}
    it {should == @plaintext_passwords.map {|plaintext_password| @c7d.encrypt(plaintext_password)}}
  end

  context "when encrypting known value matches individually as an array using short hand" do 
    before(:each) do
      @plaintext_passwords = @known_values.map {|known_value| known_value[:pt]}.uniq
      @encrypted_passwords = @c7d.e_a(@plaintext_passwords)
    end

    subject{@encrypted_passwords}
    its(:class) {should == ::Array}
    its(:size) {should == @plaintext_passwords.size}
    it {should == @plaintext_passwords.map {|plaintext_password| @c7d.encrypt(plaintext_password)}}
  end

  context "when encrypting Cisco Type-7" do 
    before(:each) do
      @plaintext_hash = "remcisco"
      @encrypted_hash = @c7d.encrypt(@plaintext_hash)
    end

    subject{@encrypted_hash}
    its(:class) {should == ::String}
    it {should == "02140156080F1C2243"}
  end

  context "when encrypting Cisco Type-7 with a seed of 15" do 
    before(:each) do
      @plaintext_hash = "remcisco"
      @seed = 15
      @encrypted_hash = @c7d.encrypt(@plaintext_hash, @seed)
    end

    subject{@encrypted_hash}
    its(:class) {should == ::String}
    it {should == "15000E010723382727"}
  end

end
