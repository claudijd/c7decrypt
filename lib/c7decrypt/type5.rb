require 'digest'

module C7Decrypt
  module Type5

    # Source Reference:
    #
    # The Ruby logic within this module was adapted
    # directly from https://github.com/mogest/unix-crypt
    #
    # Copyright (c) 2013, Roger Nesbitt
    # All rights reserved.
    #

    module Constants
      BYTE_INDEXES = [
        [0, 6, 12],
        [1, 7, 13],
        [2, 8, 14],
        [3, 9, 15],
        [4, 10, 5],
        [nil, nil, 11]
      ]
    end

    # The Encryption Method for Cisco Type-5 Encrypted Strings
    # @param [String] password
    # @param [String] salt
    # @return [String] formatted Type-5 hash
    def self.encrypt(password, salt)
      password = password.encode("UTF-8")
      password.force_encoding("ASCII-8BIT")

      b = Digest::MD5.digest("#{password}#{salt}#{password}")
      a_string = "#{password}$1$#{salt}#{b * (password.length/16)}#{b[0...password.length % 16]}"

      password_length = password.length
      while password_length > 0
        a_string += (password_length & 1 != 0) ? "\x0" : password[0].chr
        password_length >>= 1
      end

      input = Digest::MD5.digest(a_string)

      1000.times do |index|
        c_string = ((index & 1 != 0) ? password : input)
        c_string += salt unless index % 3 == 0
        c_string += password unless index % 7 == 0
        c_string += ((index & 1 != 0) ? input : password)
        input = Digest::MD5.digest(c_string)
      end

      return cisco_md5_format(salt, bit_specified_base64encode(input))
    end

    # A helper method for formating Cisco Type-5 hashes
    def self.cisco_md5_format(salt, hash)
      return "$1$" + salt + "$" + hash
    end

    # A helper method for bit specified base64 output (the format Type-5 hashes are in)
    # @param [String] input
    # @return [String] encoded_input
    def self.bit_specified_base64encode(input)
      b64 = "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
      input = input.bytes.to_a
      output = ""
      Constants::BYTE_INDEXES.each do |i3, i2, i1|
        b1, b2, b3 = i1 && input[i1] || 0, i2 && input[i2] || 0, i3 && input[i3] || 0
        output <<
          b64[  b1 & 0b00111111]         <<
          b64[((b1 & 0b11000000) >> 6) |
              ((b2 & 0b00001111) << 2)]  <<
          b64[((b2 & 0b11110000) >> 4) |
              ((b3 & 0b00000011) << 4)]  <<
          b64[ (b3 & 0b11111100) >> 2]
      end

      remainder = 3 - (16 % 3)
      remainder = 0 if remainder == 3

      return output[0..-1-remainder]
    end

  end
end
