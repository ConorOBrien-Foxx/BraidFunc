# Apr. 20, 2021. 06:11
# Okay so I just spent the last 2 hours staring at the Toadskin Source code
# And I kinda just went no, I can't be fucked.
# (And no, I don't smoke, despite the date.)

# Apr. 21, 2021. 03:13
# Work begins
require_relative "ReadStream.rb"
require_relative "Interpreter.rb"


inst = BraidFuncInterpreter.new ReadStream.from_file "examples/simple.bfnc"
inst.run
p inst