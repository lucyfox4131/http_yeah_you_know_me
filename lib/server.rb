require 'socket'
require './lib/request'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_object = Request.new
    @count_requests = 0
    start_server
  end

  def start_server
    loop do
      @request_lines = []
      @client = @tcp_server.accept
      @count_requests += 1
      get_request
      @request_object.parse_request(@request_lines)
      check_if_post
      check_the_path
      @client.close
    end
  end

  def get_request
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
  end

  def check_if_post
    if @request_object.request_hash["Verb"] == "POST"
      content_length = @request_object.request_hash["Content-Length"].to_i
      puts @client.read(content_length)
    end
  end

  def check_the_path
    if @request_object.request_hash["Path"] == "/"
      send_response
      @client.puts @request_object.request_hash
    elsif @request_object.request_hash["Path"] == "/hello"
      send_response
      hello_world
    elsif @request_object.request_hash["Path"] == "/shutdown"
      send_response
      shutdown
    elsif @request_object.request_hash["Path"] == "/datetime"
      send_response
      datetime
    elsif @request_object.request_hash["Path"].include?('/word_search')
      send_response
      word_search
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

  def word_search
    words = File.readlines('/usr/share/dict/words').map {|x| x.chomp.downcase}
    test_word = @request_object.request_hash["Path"][/word=.*/][5..-1]
    if words.include?(test_word.downcase)
      @client.puts "<html><head></head><body>#{test_word.upcase} is a known word</body></html>"
    else
      @client.puts "<html><head></head><body>#{test_word.upcase} is not a known word</body></html>"
    end
  end



end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
