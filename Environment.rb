# keeping track of the internal state of the BraidFunc program
# the program maintains a stack of these instances, one for each subroutine call
class BraidFuncEnvironment
    def initialize
        # array of ptrs, for the stack
        @ptr = 0
        # sparse storage, easily allows negative pointers
        @tape = {}
        # argument stack
        @args = []
        # following bounds are inclusive
        @cell_min = 0
        @cell_max = 256
        
    end
    
    attr_reader :tape
    
    def clamp
        @tape[@ptr] = (@tape[@ptr] - @cell_min) % @cell_max + @cell_min
    end
    
    def set_cell!(v)
        @tape[@ptr] = v
        clamp
    end
    
    def get_cell
        @tape[@ptr] ||= @cell_min
    end
    
    def truthy?
        get_cell != @cell_min
    end
    
    def falsey?
        get_cell == @cell_min
    end
    
    def increment!
        @tape[@ptr] ||= @cell_min
        @tape[@ptr] += 1
        clamp
    end
    
    def decrement!
        @tape[@ptr] ||= @cell_min
        @tape[@ptr] -= 1
        clamp
    end
    
    def move_right!
        @ptr += 1
    end
    
    def move_left!
        @ptr -= 1
    end
    
    def push_arg!
        @args << @tape[@ptr]
    end
    
    def pop_arg!
        @tape[@ptr] = @args.pop
    end
end