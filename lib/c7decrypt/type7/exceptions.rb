module C7Decrypt
  module Type7
    module Exceptions
      class InvalidFirstCharacter < StandardError
      end

      class InvalidCharacter < StandardError
      end

      class OddNumberOfCharacters < StandardError
      end

      class InvalidEncryptionSeed < StandardError
      end
    end
  end
end
