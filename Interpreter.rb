# Parses "on the fly", one character at a time
require_relative "Environment.rb"

class String
    def split_on(i)
        [ self[0...i], self[i..-1] ]
    end
end

class BraidFuncInterpreter
    # expects a ReadStream as input
    def initialize(stream)
        @stream = stream
        @state_stack = [BraidFuncEnvironment.new]
        @copying = false
        @skipping = false
        @remember = ""
        @depth = 0
        @bracket_stack = []
    end
    
    def execute_single(chr)
        case chr
        when "+"
            environment.increment!
        when "-"
            environment.decrement!
        when ">"
            environment.move_right!
        when "<"
            environment.move_left!
        when "."
            # print environment.get_cell.chr
            # debug, currently
            puts environment.get_cell
        else
            # TODO: silently ignore non-command characters
            STDERR.puts "Unimplemented: #{chr}"
        end
    end
    
    #TODO: look N characters ahead to parse multiword characters
    #TODO: command lookup tree
    #TODO: nested loops are still kind of a problem
    def execute_main(chr)
        if @depth.zero?
            @copying = false
        end
        if @skipping == @depth
            @skipping = false
        end
        if chr == "["
            @depth += 1
            if environment.falsey?
                # puts "!! SKIPPING !!"
                @skipping = @depth
            else
                @copying = true
                @bracket_stack.push @remember.size
            end
        end
        if @copying
            @remember += chr
        end
        if chr == "]"
            @depth -= 1
            if environment.truthy? and not @skipping
                to_jump = @bracket_stack.pop
                # p "to_jump: #{to_jump}"
                @remember, repeat = @remember.split_on to_jump
                # puts "Repeating: #{repeat}"
                # puts "Remembering: #{@remember}"
                # puts "Tape: #{environment.tape}"
                # puts "Queue: #{@stream.queue.inspect}"
                # puts 
                @stream.enqueue_front repeat
            else
                unless @skipping
                    @bracket_stack.pop
                    # @stream.queue.shift
                end
                # puts "!! Hopping over !!"
                # puts "Remembering: #{@remember}"
                # puts "Queue: #{@stream.queue.inspect}"
            end
        end
        return if @skipping
        return if chr == "[" || chr == "]"
        execute_single chr
    end
    
    def step
        chr = @stream.read_char
        # puts "--- step: #{chr.inspect} ---"
        execute_main chr
    end
    
    def run
        step until @stream.done?
    end
    
    def environment
        @state_stack.last
    end
end