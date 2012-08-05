require 'c7decrypt'

puts "########## EXAMPLE USAGE OF C7Decrypt ##########"
puts ""

#Example Usage
c = C7Decrypt.new()

puts "[+] Example #1 Decrypt of '060506324F41' single hash #1"
puts c.decrypt("060506324F41")
puts c.d("060506324F41")

puts "[+] Example #2 Decrypt of '0822455D0A16' single hash #2"
puts c.decrypt("0822455D0A16")
puts c.d("0822455D0A16")

puts "[+] Example #3 Decrypt of an array of hashes"

pw_array = [
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16",
  "060506324F41",
  "0822455D0A16"
]

puts c.decrypt_array(pw_array)
puts c.d_a(pw_array)

puts "[+] Example #4 Decrypt of a raw config file"

puts c.decrypt_config("examples.txt")
puts c.d_c("examples.txt")

