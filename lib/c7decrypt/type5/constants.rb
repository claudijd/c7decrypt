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
  end
end
