require 'socket'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client #@tcp_server.accept
    @count_requests = 1
    # hello_world
  end

  def hello_world
    while (@client = @tcp_server.accept)
      request_lines = []
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      output = "<html><head></head><body>#{"Hello World (#{@count_requests})"}</body></html>"
        @client.puts output
      @count_requests += 1
      @client.close
    end
  end



end

if __FILE__ == $PROGRAM_NAME
  server = Server.new.hello_world
end
