# A Ruby-based implementation of a Cisco Type-7 Password Decrypter
#
# Author: Jonathan Claudius (Twitter/GitHub: @claudijd)
#
# This code is based on Daren Matthew's cdecrypt.pl found here:
#   http://mccltd.net/blog/?p=1034 ("Deobfuscating Cisco Type 7 Passwords")

#Class Implementation
class C7Decrypt

  # Vigenere translation table (these are our key values for decryption)
  VT_TABLE = [
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f, 0x41, 0x2c, 0x2e,
    0x69, 0x79, 0x65, 0x77, 0x72, 0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44,
    0x48, 0x53, 0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36, 0x39,
    0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76, 0x39, 0x38, 0x37, 0x33,
    0x32, 0x35, 0x34, 0x6b, 0x3b, 0x66, 0x67, 0x38, 0x37
  ]

  # The Decryption Method for Cisco Type-7 Encrypted Strings
  # @param [String] the Cisco Type-7 Encrypted String
  # @return [String] the Decrypted String
  def decrypt(pw)
    r = ""
    pw_bytes = pw.scan(/../)
    vt_index = pw_bytes.first.hex - 1
    pw.scan(/../).each_with_index do |byte,i|
      r += (byte.hex^VT_TABLE[(i + vt_index) % 53]).chr  
    end
    return r.slice(1..-1)
  end

  # A helper method to decrypt an arracy of Cisco Type-7 Encrypted Strings
  # @param [Array>String] an array of Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def decrypt_array(pw_array)
    r = []
    pw_array.each do |pw|
      r << decrypt(pw)
    end
    return r
  end

  # This method scans a raw config file for type 7 passwords and decrypts them
  # @param [String] a string of the config file path that contains Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def decrypt_config(file)
    pw_array = []
    f = File.open(file, 'r')
    f.each do |line|
      pw_array << line.scan(/enable password 7 ([a-zA-Z0-9]+)/)
      pw_array << line.scan(/username [a-zA-Z0-9]+ password 7 ([a-zA-Z0-9]+)/)
    end
    decrypt_array(pw_array.flatten!)
  end

  # A short-hand version of the descrypt method
  # @param [String] the Cisco Type-7 Encrypted String
  # @return [String] the Decrypted String
  def d(pw)
    decrypt(pw)
  end

  # A short-hand version of the descrypt_array method
  # @param [Array>String] an array of Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def d_a(pw_array)
    decrypt_array(pw_array)
  end

  # A short-hand version of the decrypt_config method
  # @param [String] a string of the config file path that contains Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def d_c(file)
    decrypt_config(file)
  end

end
