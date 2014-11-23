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

## Example Command-Line Usage

Run `c7decrypt -h` to get this

    Usage: c7decrypt [option] [hash/file]
        -s, --string [HASH]              A single encrypted hash string
        -f, --file [FILE]                A file containing multiple hashes
        -h, --help                       Show this message

    Example: c7decrypt -s 04480E051A33490E
    Example: c7decrypt -f config.txt

## Example Library Usage(s)

To use, just require

```ruby
require 'c7decrypt'
```

Decrypt Cisco Type-7 Password

```ruby
>> C7Decrypt::Type7.decrypt("060506324F41")
=> "cisco"
```
Encrypt Cisco Type-7 Password

```ruby
>> C7Decrypt::Type7.encrypt("cisco")
=> "02050D480809"
```

Encrypt Cisco Type-5 Password

```ruby
>> C7Decrypt::Type5.encrypt("cisco")
=> "$1$CQk2$d62sxZKKAp7PHXWq4mOPF."
```

## Rubies Supported

This project is integrated with [travis-ci](http://about.travis-ci.org/) and is regularly tested to work with the following rubies:

* [2.1.3](https://github.com/ruby/ruby/tree/ruby_2_1)
* [2.1.0](https://github.com/ruby/ruby/tree/ruby_2_1)
* [2.0.0](https://github.com/ruby/ruby/tree/ruby_2_0_0)
* [1.9.3](https://github.com/ruby/ruby/tree/ruby_1_9_3)
* [ruby-head](https://github.com/ruby/ruby)
* [jruby-head](http://jruby.org/)
* [jruby-19mode](http://jruby.org/)

To checkout the current build status for these rubies, click [here](https://travis-ci.org/#!/claudijd/c7decrypt).

## Contributing

If you are interested in contributing to this project, please see [CONTRIBUTING.md](https://github.com/claudijd/c7decrypt/blob/master/CONTRIBUTING.md)

## Credits

**Sources of Inspiration for C7Decrypt**

- [**Daren Matthew**](http://mccltd.net/blog/?p=1034) - For his blog post on the subject aggregating tools and sources that perform the decryption/decoding logic.
- [**m00nie**](http://www.m00nie.com/2011/09/cisco-type-7-password-decryption-and-encryption-with-perl/) - For the blog post on the subject, the source code of type7tool.pl and it's encryption techniques.
- [**Roger Nesbitt (mogest)**](https://github.com/mogest/unix-crypt) - For the unix-crypt Ruby library that demonstrates Unix MD5 hashing schemes.

**Application(s) that use C7Decrypt**

- [**Marcus J Carey**](https://www.threatagent.com/c7) - For his web application implementation of this on the ThreatAgent website. Check it out and start decrypting Cisco type-7 passwords right now.
