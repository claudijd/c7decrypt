# C7Decrypt

[![Build Status](https://secure.travis-ci.org/claudijd/c7decrypt.png)](http://travis-ci.org/claudijd/c7decrypt)
[![Dependency Status](https://gemnasium.com/claudijd/c7decrypt.png)](https://gemnasium.com/claudijd/c7decrypt)
[![Code Quality](https://codeclimate.com/badge.png)](https://codeclimate.com/github/claudijd/c7decrypt)

A Ruby-based implementation of a Cisco Type-7 Password Decrypter

## Key Benefits

- **Written in Ruby** - First and only Cisco Type-7 implementation in Ruby that I know of.
- **Minimal/No Dependancies** - Uses native Ruby to do it's work, no heavy dependancies.
- **Not Just a Script** - Implementation is portable for use in another project or for automation of tasks.
- **Simple** - It's a pretty small project so the interfaces are simple and easy to use.

## Setup

To install, type

```bash
gem install c7decrypt
```

To use, just require

```ruby
require 'c7decrypt'
```

## Example Usage(s)

Decrypt A Single Cisco Type-7 Hash

```ruby
>> C7Decrypt.decrypt("060506324F41")
=> "cisco"
```

Decrypt Cisco Type-7 Hashes from Config
```ruby
>> C7Decrypt.decrypt_config("cisco_config.txt")
=> ["cisco", "Password1", "admin"]
```

Decrypt Array of Cisco Type-7 Hashes
```ruby
>> encrypted_hashes = ["060506324F41", "0822455D0A16"]
=> ["060506324F41", "0822455D0A16"]
>> C7Decrypt.decrypt_array(encrypted_hashes)
=> ["cisco", "cisco"]
```

Still interested in what this code is all about?

Check out the c7decrypt GitHub Page here:

http://claudijd.github.com/c7decrypt/
