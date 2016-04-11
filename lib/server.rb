require 'socket'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = @tcp_server.accept
  end



end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
