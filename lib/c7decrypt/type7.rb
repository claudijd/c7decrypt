module C7Decrypt
  module Type7
    
    module Constants
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
        /enable password 7 ([A-Z0-9]+)/,
        /username [A-Z0-9]+ password 7 ([A-Z0-9]+)/,
        /password 7 ([A-Z0-9]+)/
      ]
    end

    class InvalidFirstCharacter < StandardError
    end

    class InvalidCharacter < StandardError
    end

    class OddNumberOfCharacters < StandardError
    end

    class InvalidEncryptionSeed < StandardError
    end

    # The Decryption Method for Cisco Type-7 Encrypted Strings
    # @param [String] the Cisco Type-7 Encrypted String
    # @raise [InvalidFirstCharacter, 
    #         InvalidCharacter, 
    #         OddNumberOfCharacters]
    # @return [String] the Decrypted String
    def self.decrypt(e_text)
      check_type_7_errors(e_text)

      d_text = ""
      seed = nil

      e_text.scan(/../).each_with_index do |char,i|
        if i == 0
          seed = char.to_i - 1
        else
          d_text += decrypt_char(char, i, seed)
        end
      end

      return d_text
    end

    # The Encryption Method for Cisco Type-7 Encrypted Strings
    # @param [String] the plaintext password
    # @param [String] the seed for the encryption used
    # @raise [InvalidEncryptionSeed,
    #         InvalidFirstCharacter, 
    #         InvalidCharacter, 
    #         OddNumberOfCharacters]
    # @return [String] the encrypted password
    def self.encrypt(d_text, seed = 2)
      check_seed(seed)
    
      e_text = sprintf("%02d", seed)

      d_text.each_char.each_with_index do |d_char,i|
        e_text += encrypt_char(d_char, i, seed)
      end

      check_type_7_errors(e_text)

      return e_text
    end

    # The method for encrypting a single character
    # @param [String] the plain text char
    # @param [FixNum] the index of the char in plaintext string
    # @param [FixNum] the seed used in the encryption process
    # @return [String] the string of the encrypted char
    def self.encrypt_char(char, i, seed)
      sprintf("%02X", char.unpack('C')[0] ^ Constants::VT_TABLE[(i + seed) % 53])
    end

    # The method for decrypting a single character
    # @param [String] the encrypted char
    # @param [Integer] the index of the char pair in encrypted string
    # @param [Integer] the seed used in the decryption process
    # @return [String] the string of the decrypted char
    def self.decrypt_char(char, i, seed)
      (char.hex^Constants::VT_TABLE[(i + seed) % 53]).chr
    end

    # A helper method to decrypt an arracy of Cisco Type-7 Encrypted Strings
    # @param [Array>String] an array of Cisco Type-7 Encrypted Strings
    # @raise [InvalidFirstCharacter, 
    #         InvalidCharacter, 
    #         OddNumberOfCharacters]
    # @return [Array>String] an array of Decrypted Strings
    def self.decrypt_array(pw_array)
      pw_array.collect {|pw| decrypt(pw)}
    end

    # A helper method to encrypt an arracy of passwords
    # @param [Array>String] an array of plain-text passwords
    # @raise [InvalidEncryptionSeed,
    #         InvalidFirstCharacter, 
    #         InvalidCharacter, 
    #         OddNumberOfCharacters]
    # @return [Array>String] an array of encrypted passwords
    def self.encrypt_array(pt_array, seed = 2)
      pt_array.collect {|pw| encrypt(pw, seed)}
    end

    # This method scans a raw config file for type 7 passwords and 
    #   decrypts them
    # @param [String] a string of the config file path that contains
    #   Cisco Type-7 Encrypted Strings
    # @raise [InvalidFirstCharacter, 
    #         InvalidCharacter, 
    #         OddNumberOfCharacters]
    # @return [Array>String] an array of Decrypted Strings
    def self.decrypt_config(file)
      f = File.open(file, 'r').to_a
      decrypt_array(f.collect {|line| type_7_matches(line)}.flatten)
    end

    # This method scans a config line for encrypted type-7 passwords and
    #   returns an array of results
    # @param [String] a line with potential encrypted type-7 passwords
    # @return [Array>String] an array of Cisco type-7 encrypted Strings
    def self.type_7_matches(string)
      Constants::TYPE_7_REGEXES.collect {|regex| string.scan(regex)}.flatten.uniq
    end

    # This method determines if an encrypted hash is corrupted/invalid 
    #   and throw a specific exeception
    # @param [String] the Cisco Type-7 Encrypted String
    # @raise [InvalidFirstCharacter, InvalidCharacter, OddNumberOfCharacters]
    # @return [Nil]
    def self.check_type_7_errors(e_text)
      
      valid_first_chars = (0..15).to_a.collect {|c| sprintf("%02d", c)}
      first_char = e_text[0,2]

      # Check for an invalid first character in the has
      unless valid_first_chars.include? first_char
        raise InvalidFirstCharacter, 
          "'#{e_text}' hash contains an invalid first chracter (only '00' - '15' allowed)"
      end

      # Check for an invalid character in the hash
      unless e_text.match(/^[A-Z0-9]+$/)
        raise InvalidCharacter,
          "'#{e_text}' hash contains an invalid character (only upper-alpha numeric allowed)"
      end

      # Check for an odd number of characters in the hash
      unless e_text.size % 2 == 0
        raise OddNumberOfCharacters,
          "'#{e_text}' hash contains odd length of chars (only even number of chars allowed)"     
      end

      return nil

    end

    # This method determines if an encryption seed is valid or not
    #   and throw a specific exeception
    # @param [FixNum] the seed used in the encryption process
    # @raise [InvalidEncryptionSeed] 
    # @return [Nil]
    def self.check_seed(seed)
      if seed < 0 ||
         seed > 15
        
        raise InvalidEncryptionSeed,
          "'#{seed.to_s}' seed is not a valid seed (only 0 - 15 allowed)"
      end

      return nil
    end

  end
end
