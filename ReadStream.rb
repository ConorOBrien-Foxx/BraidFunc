# wrapper to handle reading from a string, file, STDIN, etc.
# TODO: allow initialization after constructor?
class ReadStream
    def initialize(arg)
        @source = arg
        @ptr = 0
        @direct_readable = false
        if @source.class.method_defined? :read
            @ptr = nil
            @direct_readable = true
        end
    end
    
    def done?
        if @direct_readable
            a.eof?
        else
            @ptr >= @source.size
        end
    end
    
    def read(n = 1)
        if @direct_readable
            @source.read n
        else
            build = @source.class.new
            n.times {
                break if done?
                build << @source[@ptr]
                @ptr += 1
            }
            build
        end
    end
end
