module C7Decrypt
  module Type7
    module Exceptions
      # Use when the first character of a hash is invalid (they should be 0-15)
      class InvalidFirstCharacter < StandardError
      end

      # Use when an invalid character is detected in a hash (they should be alpha-num)
      class InvalidCharacter < StandardError
      end

      # Use when a hash contains an odd number of characters (they should all be even)
      class OddNumberOfCharacters < StandardError
      end

      # Use when an invalid seed is requested when encrypting
      class InvalidEncryptionSeed < StandardError
      end
    end
  end
end
