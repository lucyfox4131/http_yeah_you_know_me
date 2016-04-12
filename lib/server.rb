require 'socket'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    # @client #@tcp_server.accept
    @count_requests = 0
    # @request_lines = []
    start_server
  end

  def start_server
    loop do
      @request_lines = []
      @client = @tcp_server.accept
      @count_requests += 1
      get_request
      parse_request
      check_the_path
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
    host = @request_lines[1].split(': ')[1].split(':')[0]
    port = @request_lines[1].split(': ')[1].split(':')[1]
    @request_hash = {"verb" => verb, "path" => path, "protocol" => protocol, "host" => host, "port" => port}
    @request_lines[2...@request_lines.length].each do |line|
      new_variable = line.split(': ')
      @request_hash[new_variable[0]] = new_variable[1]
    end
  end

  def check_the_path
    if @request_hash["path"] == "/"
      send_response
      @client.puts @request_hash
    elsif @request_hash["path"] == "/hello"
      send_response
      hello_world
    elsif @request_hash["path"] == "/shutdown"
      send_response
      shutdown
    elsif @request_hash["path"] == "/datetime"
      send_response
      datetime
    end
  end

  def send_response
    status = "HTTP/1.1 200 OK\n\r"
    @client.puts status
  end

  def hello_world
    @client.puts "<html><head></head><body>#{"Hello World (#{@count_requests})\n This is our request: #{@request_lines}"}</body></html>"
  end

  def shutdown
    @client.puts "<html><head></head><body>#{"Total Requests: #{@count_requests}"}</body></html>"
    @tcp_server.close
  end

  def datetime
    @client.puts "<html><head></head><body>#{Time.now.strftime('%l:%M%p on %A, %B %e, %Y')}</body></html>"
  end

# 11:07AM on Sunday, November 1, 2015.
# on #{Time.new.wday}, #{Time.new.month} #{Time.new.day}, #{Time.new.year}


end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
