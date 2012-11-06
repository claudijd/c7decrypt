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

  # Regexes for extracting hashes from configs
  TYPE_7_REGEXES = [
    /enable password 7 ([a-zA-Z0-9]+)/,
    /username [a-zA-Z0-9]+ password 7 ([a-zA-Z0-9]+)/,
    /password 7 ([a-zA-Z0-9]+)/
  ]

  # The Decryption Method for Cisco Type-7 Encrypted Strings
  # @param [String] the Cisco Type-7 Encrypted String
  # @return [String] the Decrypted String
  def decrypt(pw)
    r = ""
    pw_bytes = pw.scan(/../)
    vt_index = pw_bytes.first.hex - 1
    pw_bytes.each_with_index do |byte,i|
      r += (byte.hex^VT_TABLE[(i + vt_index) % 53]).chr
    end
    return r.slice(1..-1).rstrip
  end

  # The Encryption Method for Cisco Type-7 Encrypted Strings
  # @param [String] the plaintext password
  # @param [String] the seed for the encryption used 
  # @return [String] the encrypted password
  def encrypt(plain_text, seed = 2)
    etext = "%02d" % seed
    pt_chars = plain_text.scan(/./)
    pt_chars.each_with_index do |char,i|
      tmp = char.ord ^ VT_TABLE[(i + seed)]
      etext += ("%02X" % tmp)
    end
    return etext
  end

  # A helper method to decrypt an arracy of Cisco Type-7 Encrypted Strings
  # @param [Array>String] an array of Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def decrypt_array(pw_array)
    pw_array.collect {|pw| decrypt(pw)}
  end

  # A helper method to encrypt an arracy of passwords
  # @param [Array>String] an array of plain-text passwords
  # @return [Array>String] an array of encrypted passwords
  def encrypt_array(pt_array, seed = 2)
    pt_array.collect {|pw| encrypt(pw, seed)}
  end

  # This method scans a raw config file for type 7 passwords and decrypts them
  # @param [String] a string of the config file path that contains Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def decrypt_config(file)
    f = File.open(file, 'r').to_a
    decrypt_array(f.collect {|line| type_7_matches(line)}.flatten)
  end

  # This method scans a config line for encrypted type-7 passwords and returns an array of results
  # @param [String] a line with potential encrypted type-7 passwords
  # @return [Array>String] an array of Cisco type-7 encrypted Strings
  def type_7_matches(string)
    TYPE_7_REGEXES.collect {|regex| string.scan(regex)}.flatten.uniq
  end

  # A short-hand version of the decrypt method
  # @param [String] the password hash
  # @return [String] the plaintest password
  def d(pw)
    decrypt(pw)
  end

  # A short-hand version of the encrypt method
  # @param [String] the plaintext password
  # @return [String] the password hash
  def e(pt, seed = 2)
    encrypt(pt, seed)
  end

  # A short-hand version of the descrypt_array method
  # @param [Array>String] an array of password hashes
  # @return [Array>String] an array of plaintext passwords
  def d_a(pw_array)
    decrypt_array(pw_array)
  end

  # A short-hand version of the descrypt_array method
  # @param [Array>String] an array of Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def e_a(pt_array, seed = 2)
    encrypt_array(pt_array, seed)
  end

  # A short-hand version of the decrypt_config method
  # @param [String] a string of the config file path that contains Cisco Type-7 Encrypted Strings
  # @return [Array>String] an array of Decrypted Strings
  def d_c(file)
    decrypt_config(file)
  end

end
