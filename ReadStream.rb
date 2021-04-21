# wrapper to handle reading from a string, file, STDIN, etc.
# TODO: allow initialization after constructor?
class ReadStream
    def initialize(arg)
        @source = arg
        @ptr = 0
        @direct_readable = false
        @queue = []
        if @source.class.method_defined? :read
            @ptr = nil
            @direct_readable = true
        end
    end
    
    attr_reader :queue
    
    def done?
        return false unless @queue.empty?
        
        if @direct_readable
            @source.eof?
        else
            @ptr >= @source.size
        end
    end
    
    def enqueue(data)
        data = ReadStream.from(data)
        @queue << data
    end
    
    def enqueue_front(data)
        data = ReadStream.from(data)
        @queue.unshift data
    end
    
    def read(n = 1)
        if not @queue.empty?
            sub = @queue.first.read n
            n -= sub.size
            while not @queue.empty? and @queue.first.done?
                @queue.shift
            end
            unless n.zero?
                sub << read(n)
            end
            sub
        elsif @direct_readable
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
    
    def read_all
        composite = nil
        if @direct_readable
            composite = ""
        else
            composite = @source.class.new
        end
        
        until @queue.empty?
            composite << @queue.shift.read_all
        end
        
        if @direct_readable
            composite << @source.read
        else
            composite << @source
        end
        composite
    end
    
    def read_char
        read 1
    end
    
    def self.from_file(file_name)
        ReadStream.new File.open file_name
    end
    
    def self.from(data)
        data = ReadStream.new(data) unless data.is_a? ReadStream
        data
    end
end

# stream = ReadStream.new ""
# loop {
    # print "> "
    # cmd = STDIN.gets
    # if cmd[0] == ":"
        # stream.enqueue cmd[1..-1].chomp
    # elsif cmd[0] == "!"
        # n = cmd[1..-1].to_i
        # n = 1 if n.zero?
        # puts "Reading:"
        # p stream.read n
    # elsif cmd[0] == "~"
        # p stream.read_all
    # end
    # break if stream.done?
# }
