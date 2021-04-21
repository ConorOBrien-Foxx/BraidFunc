# Apr. 20, 2021. 06:11
# Okay so I just spent the last 2 hours staring at the Toadskin Source code
# And I kinda just went no, I can't be fucked.
# (And no, I don't smoke, despite the date.)

# Apr. 21, 2021. 03:13
# Work begins
require_relative "ReadStream.rb"

# a = ReadStream.new STDIN
a = ReadStream.new File.open "README.md"

13.times {
    puts a.read 1
}