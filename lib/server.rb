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
    @request_hash = {"verb" => verb, "path" => path, "protocol" => protocol}
    @request_lines[1...@request_lines.length].each do |line|
      new_variable = line.split(': ')
      @request_hash[new_variable[0]] = new_variable[1]
    end
    check_the_path
  end

  def check_the_path
    if @request_hash["path"] == "/"
      @client.puts @request_hash
    elsif @request_hash["path"] == "/hello"
      hello_world
    elsif @request_hash["path"] == "/shutdown"
      shutdown
    elsif @request_hash["path"] == "/datetime"
      datetime
    end
  end

  def send_response

  end

  def hello_world
      output = "<html><head></head><body>#{"Hello World (#{@count_requests})\n This is our request: #{@request_lines}"}</body></html>"
        @client.puts output
  end

  def shutdown
    output = "<html><head></head><body>#{"Total Requests: #{@count_requests}"}</body></html>"
    @client.puts output
    @tcp_server.close
  end

  def datetime
    output = "<html><head></head><body>#{Time.now.strftime('%l:%M%p on %A, %B %e, %Y')}</body></html>"
    @client.puts output
  end

# 11:07AM on Sunday, November 1, 2015.
# on #{Time.new.wday}, #{Time.new.month} #{Time.new.day}, #{Time.new.year}


end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
