require 'c7decrypt'
require 'rspec/its'

describe C7Decrypt::Type7 do

  before(:each) do
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

  context "when decrypting single Cisco Type-7 hash using longhand" do
    before(:each) do
      @encrypted_hash = "060506324F41"
      @decrypted_hash = C7Decrypt::Type7.decrypt(@encrypted_hash)
    end

    it "should be the right class and value" do
      expect(@decrypted_hash).to be_kind_of(::String)
      expect(@decrypted_hash).to eql("cisco")
    end
  end

  context "when decrypting an array of Cisco Type-7 hashes" do
    before(:each) do
      @encrypted_hashes = [
        "060506324F41",
        "0822455D0A16"
      ]
      @decrypted_hashes = C7Decrypt::Type7.decrypt_array(@encrypted_hashes)
    end

    it "should be the right class and values" do
      expect(@decrypted_hashes).to be_kind_of(::Array)
      expect(@decrypted_hashes.first).to eql("cisco")
      expect(@decrypted_hashes.last).to eql("cisco")
      expect(@decrypted_hashes.size).to eql(2)
    end
  end

  context "when decrypting Cisco Type-7 hashes from a config" do
    before(:each) do
      @config_file = "./spec/example_configs/simple_canned_example.txt"
      @decrypted_hashes = C7Decrypt::Type7.decrypt_config(@config_file)
    end

    it "should be the right class and values" do
      expect(@decrypted_hashes).to be_kind_of(::Array)
      expect(@decrypted_hashes.first).to eql("cisco")
      expect(@decrypted_hashes.last).to eql("cisco")
      expect(@decrypted_hashes.size).to eql(5)
    end
  end

  context "when decrypting known Cisco Type-7 known value matches" do
    before(:each) do
      @decrypted_hashes = C7Decrypt::Type7.decrypt_array(
                            @known_values.map {|known_value| known_value[:ph]}
                          )
    end

    it "should be the right class and values" do
      expect(@decrypted_hashes).to be_kind_of(::Array)
      expect(@decrypted_hashes.size).to eql(@known_values.size)
      expect(@decrypted_hashes).to eql(@known_values.map {|known_value| known_value[:pt]})
    end
  end

  context "when decrypting Cisco Type-7 with a seed greater than 9" do
    before(:each) do
      @decrypt_hash = C7Decrypt::Type7.decrypt("15000E010723382727")
    end

    it "should be the right class and values" do
      expect(@decrypt_hash).to be_kind_of(::String)
      expect(@decrypt_hash).to eql("remcisco")
    end
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
        @encrypted_hashes << C7Decrypt::Type7.type_7_matches(k)
      end
      @encrypted_hashes.flatten!
    end

    it "should be the right class and values" do
      expect(@encrypted_hashes).to be_kind_of(::Array)
      expect(@encrypted_hashes.size).to eql(@known_config_lines.size)
      expect(@encrypted_hashes).to eql(@known_config_lines.values)
    end
  end

  context "when encrypting single Cisco Type-7 hash" do
    before(:each) do
      @plaintext_hash = "cisco"
      @encrypted_hash = C7Decrypt::Type7.encrypt(@plaintext_hash)
    end

    it "should be the right class and values" do
      expect(@encrypted_hash).to be_kind_of(::String)
      expect(@encrypted_hash).to eql("02050D480809")
    end
  end

  context "when encrypting single Cisco Type-7 hash with an alternate seed value" do
    before(:each) do
      @plaintext_hash = "cisco"
      @seed = 3
      @encrypted_hash = C7Decrypt::Type7.encrypt(@plaintext_hash, @seed)
    end

    it "should be the right class and values" do
      expect(@encrypted_hash).to be_kind_of(::String)
      expect(@encrypted_hash).to eql("030752180500")
      expect(C7Decrypt::Type7.decrypt(@encrypted_hash)).to eql(@plaintext_hash)
    end
  end

  context "when encrypting multiple plaintext passwords with alternate seed values" do
    before(:each) do
      @plaintext_hash = "cisco"
      @seeds = 0..15
      @encrypted_hashes = @seeds.map {|seed| C7Decrypt::Type7.encrypt(@plaintext_hash, seed)}
    end

    it "should be the right class and values" do
      expect(@encrypted_hashes).to be_kind_of(::Array)
      @encrypted_hashes.each do |encrypted_hash|
        expect(C7Decrypt::Type7.decrypt(encrypted_hash)).to eql(@plaintext_hash)
      end
    end
  end

  context "when encrypting known value matches individually" do
    before(:each) do
      @encrypted_hashes = []
      @known_values.each do |known_value|
        @encrypted_hashes << C7Decrypt::Type7.encrypt(known_value[:pt], known_value[:seed])
      end
    end

    it "should be the right class and values" do
      expect(@encrypted_hashes).to be_kind_of(::Array)
      expect(@encrypted_hashes.size).to eql(@known_values.size)
      expect(@encrypted_hashes).to eql(@known_values.map {|known_value| known_value[:ph]})
    end
  end

  context "when encrypting known value matches individually as an array" do
    before(:each) do
      @plaintext_passwords = @known_values.map {|known_value| known_value[:pt]}.uniq
      @encrypted_passwords = C7Decrypt::Type7.encrypt_array(@plaintext_passwords)
    end

    it "should be the right class and values" do
      expect(@encrypted_passwords).to be_kind_of(::Array)
      expect(@encrypted_passwords.size).to eql(@plaintext_passwords.size)
      expect(@encrypted_passwords).to eql(@plaintext_passwords.map {|plaintext_password| C7Decrypt::Type7.encrypt(plaintext_password)})
    end
  end

  context "when encrypting Cisco Type-7" do
    before(:each) do
      @plaintext_hash = "remcisco"
      @encrypted_hash = C7Decrypt::Type7.encrypt(@plaintext_hash)
    end

    it "should be the right class and values" do
      expect(@encrypted_hash).to be_kind_of(::String)
      expect(@encrypted_hash).to eql("02140156080F1C2243")
    end
  end

  context "when encrypting Cisco Type-7 with a seed of 15" do
    before(:each) do
      @plaintext_hash = "remcisco"
      @seed = 15
      @encrypted_hash = C7Decrypt::Type7.encrypt(@plaintext_hash, @seed)
    end

    it "should be the right class and values" do
      expect(@encrypted_hash).to be_kind_of(::String)
      expect(@encrypted_hash).to eql("15000E010723382727")
    end
  end

  context "when trying to decrypt a hash with an invalid first character" do
    it "should raise an InvalidFirstCharacter Exception" do
      expect {
        C7Decrypt::Type7.decrypt("AA000E010723382727")
      }.to raise_error(C7Decrypt::Type7::InvalidFirstCharacter)
    end
  end

  context "when trying to decrypt a hash with an invalid character" do
    it "should raise an InvalidFirstCharacter Exception" do
      expect {
        C7Decrypt::Type7.decrypt("06000**E010723382727")
      }.to raise_error(C7Decrypt::Type7::InvalidCharacter)
    end
  end

  context "when trying to decrypt a hash with an odd number of characters" do
    it "should raise an InvalidFirstCharacter Exception" do
      expect {
        C7Decrypt::Type7.decrypt("06000E01723382727")
      }.to raise_error(C7Decrypt::Type7::OddNumberOfCharacters)
    end
  end

  context "when trying to encrypt a hash with an invalid high encryption seed" do
    it "should raise an InvalidFirstCharacter Exception" do
      expect {
        C7Decrypt::Type7.encrypt("bananas", 16)
      }.to raise_error(C7Decrypt::Type7::InvalidEncryptionSeed)
    end
  end

  context "when trying to encrypt a hash with an invalid low encryption seed" do
    it "should raise an InvalidFirstCharacter Exception" do
      expect {
        C7Decrypt::Type7.encrypt("bananas", -1)
      }.to raise_error(C7Decrypt::Type7::InvalidEncryptionSeed)
    end
  end

end
