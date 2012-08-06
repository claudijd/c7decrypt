require 'c7decrypt'

describe C7Decrypt do

	before(:each) do
		@c7d = C7Decrypt.new()
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
			@known_values = {
				"046E1803362E595C260E0B240619050A2D" => "UseYourOwnString",
				"060506324F41" => "cisco",
				"0822455D0A16" => "cisco",
				"04480E051A33490E" => "secure",
				"095C4F1A0A1218000F" => "password",
				"07362E590E1B1C041B1E124C0A2F2E206832752E1A01134D" => "You really need a life.",
				"02050D480809" => "cisco",
				"044B0A151C36435C0D" => "password",
				"05080F1C2243" => "cisco",
				"094F471A1A0A" => "cisco"
			}
			@decrypted_hashes = @c7d.decrypt_array(@known_values.keys)
		end
		
		subject{@decrypted_hashes}
		its(:class) {should == ::Array}
		its(:size) {should == @known_values.size}
		it {should == @known_values.values}
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

end