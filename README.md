A Ruby-based implementation of a Cisco Type-7 Password Decrypter

Author: Jonathan Claudius (Twitter/GitHub: @claudijd)

This code is based on Daren Matthew's cdecrypt.pl found here:

http://mccltd.net/blog/?p=1034 ("Deobfuscating Cisco Type 7 Passwords")

Example Usage via IRB:

`>> require 'c7decrypt'
=> true
>> c7d = C7Decrypt.new()
=> #<C7Decrypt:0x131d888>

>> puts "Example #1 - Decrypt Single Hash"
>> c7d.decrypt("060506324F41")
=> "cisco"

>> puts "Example #2 - Decrypt Hashes from Config"
>> c7d.decrypt_config("../spec/example_configs/simple_canned_example.txt")
=> ["cisco", "cisco", "cisco", "cisco", "cisco"]

>> puts "Example #3 - Decrypt Array of Hashes"
>> encrypted_hashes = ["060506324F41", "0822455D0A16"]
=> ["060506324F41", "0822455D0A16"]
>> c7d.decrypt_array(encrypted_hashes)
=> ["cisco", "cisco"]`