![Cisco Logo](https://github.com/claudijd/c7decrypt/blob/master/images/cisco.jpeg?raw=true)

# C7Decrypt

[![Build Status](https://secure.travis-ci.org/claudijd/c7decrypt.png)](http://travis-ci.org/claudijd/c7decrypt)
[![Dependency Status](https://gemnasium.com/claudijd/c7decrypt.png)](https://gemnasium.com/claudijd/c7decrypt)
[![Code Climate](https://codeclimate.com/github/claudijd/c7decrypt.png)](https://codeclimate.com/github/claudijd/c7decrypt)

A Ruby-based implementation of a Cisco Type-7 Password Encryptor/Decryptor

## Key Benefits

- **Written in Ruby** - First and only Cisco Type-7 implementation in Ruby that I know of.
- **Minimal/No Dependancies** - Uses native Ruby to do it's work, no heavy dependancies.
- **Not Just a Script** - Implementation is portable for use in another project or for automation of tasks.
- **Simple** - It is a small project so the interfaces are simple and easy to use.
- **Encrypt & Decrypt** - Supports both encryption (with seed control) and decryption operations.

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

Decrypt A Single Encrypted Passwords

```ruby
>> C7Decrypt.decrypt("060506324F41")
=> "cisco"
```

Decrypt Array of Encrypted Passwords

```ruby
>> encrypted_hashes = ["060506324F41", "0822455D0A16"]
=> ["060506324F41", "0822455D0A16"]
>> C7Decrypt.decrypt_array(encrypted_hashes)
=> ["cisco", "cisco"]
```

Decrypt Encrypted Passwords from Config

```ruby
>> C7Decrypt.decrypt_config("cisco_config.txt")
=> ["cisco", "Password1", "admin"]
```

Encrypt A Single Plaintext Password

```ruby
>> C7Decrypt.encrypt("cisco")
=> "02050D480809"
```

Encrypt A Single Plaintext Password w/ Explicit Seed

```ruby
>> C7Decrypt.encrypt("cisco", 6)
=> "060506324F41"
```

Encrypt An Array of Plaintext Passwords

```ruby
>> passwords = ["cisco", "password"]
=> ["cisco", "password"]
>> C7Decrypt.encrypt_array(passwords)
=> ["02050D480809", "021605481811003348"]
```

## Rubies Supported

This project is integrated with [travis-ci](http://about.travis-ci.org/) and is regularly tested to work with the following rubies:

* [2.0.0](https://github.com/ruby/ruby/tree/ruby_2_0_0)
* [1.9.3](https://github.com/ruby/ruby/tree/ruby_1_9_3)
* [1.9.2](https://github.com/ruby/ruby/tree/ruby_1_9_2)
* 1.9.1 - Tested outside of Travis-CI
* [1.8.7](https://github.com/ruby/ruby/tree/ruby_1_8_7)
* 1.8.6 - Tested outside of Travis-CI
* [ruby-head](https://github.com/ruby/ruby)
* [jruby-head](http://jruby.org/)
* [jruby-19mode](http://jruby.org/)
* [jruby-18mode](http://jruby.org/)
* [rbx-19mode](http://rubini.us/)
* [rbx-18mode](http://rubini.us/)
* [ree](http://www.rubyenterpriseedition.com/)

To checkout the current build status for these rubies, click [here](https://travis-ci.org/#!/claudijd/c7decrypt).

## Contributing

If you are interested in contributing to this project, please see [CONTRIBUTING.md](https://github.com/claudijd/c7decrypt/blob/master/CONTRIBUTING.md)

## Credits

**Sources of Inspiration for C7Decrypt**

- [**Daren Matthew**](http://mccltd.net/blog/?p=1034) - For his blog post on the subject aggregating tools and sources that perform the decryption/decoding logic.
- [**m00nie**](http://www.m00nie.com/2011/09/cisco-type-7-password-decryption-and-encryption-with-perl/) - For the blog post on the subject, the source code of type7tool.pl and it's encryption techniques.

**Application(s) that use C7Decrypt**

- [**Marcus J Carey**](https://www.threatagent.com/c7) - For his web application implementation of this on the ThreatAgent website. Check it out and start decrypting Cisco type-7 passwords right now.
