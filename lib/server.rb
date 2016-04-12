require 'socket'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    # @client #@tcp_server.accept
    @count_requests = 1
    # @request_lines = []
    start_server
  end

  def start_server
    loop do
      @request_lines = []
      @client = @tcp_server.accept
      get_request
      parse_request
      @client.close
    end
  end

  def get_request
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
  end

  def parse_request
    verb = @request_lines[0].split[0]
    path = @request_lines[0].split[1]
    protocol = @request_lines[0].split[2]
    request_hash = {"verb" => verb, "path" => path, "protocol" => protocol}
    @request_lines[1...@request_lines.length].each do |line|
      new_variable = line.split(': ')
      request_hash[new_variable[0]] = new_variable[1]
    end
  end

  def do_stuff

  end

  def send_response

  end

  def hello_world
    while (@client = @tcp_server.accept)
      output = "<html><head></head><body>#{"Hello World (#{@count_requests}) and this is our request #{@request_lines}"}</body></html>"
        @client.puts output
      @count_requests += 1
      @client.close
    end
  end

  def shutdown
    @client = @tcp_server.accept
    output = "<html><head></head><body>#{"Total Requests: 12"}</body></html>"
    @client.puts output
    @tcp_server.close
  end

  def datetime
    @client = @tcp_server.accept
    time = Time.new
    output = "<html><head></head><body>#{Time.new.hour} + #{":"} + #{Time.new.minute} + #{" on "} + #{Time.new.wday}</body></html>"
    @client.puts output
    @client.close
  end

# 11:07AM on Sunday, November 1, 2015.
# on #{Time.new.wday}, #{Time.new.month} #{Time.new.day}, #{Time.new.year}


end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
