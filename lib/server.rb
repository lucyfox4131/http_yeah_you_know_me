require 'socket'
require './lib/request'

class Server

  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @request_object = Request.new
    @count_requests = 0
    @game_in_progess = false
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
      @post_body = @client.read(content_length)
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
    elsif @request_object.request_hash["Path"] == '/start_game'
      start_game
    elsif @request_object.request_hash["Path"] == '/game'
      game
    elsif @request_object.request_hash["Path"] == '/force_error'
      system_error
    else
      unknown_path
    end
  end

  def send_response
    status = "HTTP/1.1 200 OK\n\r"
    @client.puts status
  end

  def unknown_path
    status = "HTTP/1.1 404 Not Found\n\r"
    @client.puts status
  end

  def forbidden
    status = "HTTP/1.1 403 Forbidden\n\r"
    @client.puts status
  end

  def system_error
    status = "HTTP/1.1 500 Internal Server Error\n\r"
    @client.puts status
    @client.puts "<html><head></head><body><pre>#{caller.join("\r\n")}</pre></body></html>"
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

  def start_game
    if game_not_in_progress?
      @game_in_progess = true
      @num_guesses = 0
      @client.puts "Good luck!"
      @rand_number = rand(101)
    end
  end

  def game_not_in_progress?
    if @game_in_progess
      forbidden
      @client.puts "Game already in progress."
      return false
    else
      send_response
      return true
    end
  end

  def game
    if @request_object.request_hash["Verb"] == "POST"
      game_post_redirect
    elsif @request_object.request_hash["Verb"] == "GET"
      game_get
    end
  end

  def game_post_redirect
    status = "HTTP/1.1 302 Moved Temporarily\n"
    location = "Location: http://127.0.0.1:9292/game\n\r"
    @client.puts status + location
  end

  def game_get
    send_response
    user_guess = @post_body.to_i
    if check_if_valid_guess(user_guess)
      @num_guesses += 1
      if user_guess < @rand_number
        @client.puts "That guess is too low. Try again! You've taken #{@num_guesses} guesses."
      elsif user_guess > @rand_number
        @client.puts "That guess is too high. Try again! You've taken #{@num_guesses} guesses."
      else
        @game_in_progess = false
        @client.puts "WOOHOO You've won the game. Great guess! You took #{@num_guesses} guesses."
      end
    end
  end

  def check_if_valid_guess(user_guess)
    if @post_body.empty? || user_guess < 0 || user_guess > 100
      @client.puts "Sorry, that is not a valid guess. Please enter a number between 0 and 100."
      return false
    else
      return true
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  server = Server.new
end
