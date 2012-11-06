# C7Decrypt

[![Build Status](https://secure.travis-ci.org/claudijd/c7decrypt.png)](http://travis-ci.org/claudijd/c7decrypt)
[![Dependency Status](https://gemnasium.com/claudijd/c7decrypt.png)](https://gemnasium.com/claudijd/c7decrypt)
[![Code Quality](https://codeclimate.com/badge.png)](https://codeclimate.com/github/claudijd/c7decrypt)

A Ruby-based implementation of a Cisco Type-7 Password Encryptor/Decryptor

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

Get an instance of C7Decrypt

```ruby
>> cd = C7Decrypt.new()
=> #<C7Decrypt:0x11b1700>
```

Decrypt A Single Encrypted Passwords
```ruby
>> cd.decrypt("060506324F41")
=> "cisco"
```

Decrypt Array of Encrypted Passwords
```ruby
>> encrypted_hashes = ["060506324F41", "0822455D0A16"]
=> ["060506324F41", "0822455D0A16"]
>> cd.decrypt_array(encrypted_hashes)
=> ["cisco", "cisco"]
```

Decrypt Encrypted Passwords from Config
```ruby
>> cd.decrypt_config("cisco_config.txt")
=> ["cisco", "Password1", "admin"]
```

Encrypt A Single Plaintext Password
```ruby
>> cd.encrypt("cisco")
=> "02050D480809"
```

Encrypt A Single Plaintext Password w/ Explicit Seed
```ruby
>> cd.encrypt("cisco", 6)
=> "060506324F41"
```

Encrypt An Array of Plaintext Passwords
```ruby
>> passwords = ["cisco", "password"]
=> ["cisco", "password"]
>> cd.encrypt_array(passwords)
=> ["02050D480809", "021605481811003348"]
```

## Rubies Supported

This project is integrated with [travis-ci](http://about.travis-ci.org/) and is regularly tested to work with the following rubies:

* 1.9.3
* 1.9.2
* ruby-head
* jruby-19mode
* jruby-head

To checkout the current build status for these rubies, click the [here](https://travis-ci.org/#!/claudijd/c7decrypt).

## Contributing

If you're interesting contributing to this project, please see [CONTRIBUTING.md](https://github.com/claudijd/c7decrypt/blob/master/CONTRIBUTING.md)

## Credits

The decryption code in this project was inspired by Daren Matthew's cdecrypt.pl tool, which performs Cisco Type-7 decrypt operations in Perl.

Daren's tool can be found here in a blog post he wrote a while back:

[Deobfuscating Cisco Type 7 Passwords](http://mccltd.net/blog/?p=1034)

The encryption code in this project was inspired by a blog post at Moonie.com, which performs Cisco Type-7 decryptions and encryption operations in Perl.

The moonie.com blog post, which contains the original perl source can be found here:

[Cisco (type 7) password decryption and encryption with Perl](http://www.m00nie.com/2011/09/cisco-type-7-password-decryption-and-encryption-with-perl/)
