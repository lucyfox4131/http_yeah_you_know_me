require 'socket'
require 'thread'
require './lib/request'
require './lib/game'
require './lib/response'
require './lib/system_error'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_object = Request.new
    @response_object = Response.new
    @game_object = Game.new
    @count_requests = 0
    start_server
  end

  def start_server
    loop do
      @client = @tcp_server.accept
      @request_lines = []
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
      @post_body = @client.read(content_length)
    end
  end

  def check_the_path
    path = @request_object.request_hash["Path"]
    if path == "/"
      send_response
      @client.puts @request_object.formatted_diagnostic
    elsif path == "/hello"
      send_response
      @response_object.hello_world(@client, @request_object)
    elsif path == "/shutdown"
      shutdown
    elsif path == "/datetime"
      send_response
      @response_object.datetime(@client, @request_object)
    elsif path.include?('/word_search')
      send_response
      @response_object.word_search(@client, @request_object)
    elsif path == '/start_game'
      @game_object.start_game(@client)
    elsif path == '/game'
      @game_object.game(@client, @request_object, @post_body)
    elsif path == '/force_error'
      system_error
    elsif path == '/sleepy'
      send_response
      @client.puts "yawn..."
    else
      unknown_path
    end
  end

  def send_response
    @client.puts "HTTP/1.1 200 OK\n\r"
  end

  def unknown_path
    @client.puts "HTTP/1.1 404 Not Found\n\r"
  end

  def system_error
    @client.puts "HTTP/1.1 500 Internal Server Error\n\r"
    @client.puts "#{caller.join("\r\n")}"
    begin
      @client.puts raise SystemError
    rescue SystemError
    end
  end

  def shutdown
    send_response
    @client.puts "Total Requests: #{@count_requests}\nCurrent request:\n#{@request_object.formatted_diagnostic}"
    @tcp_server.close
  end

end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
