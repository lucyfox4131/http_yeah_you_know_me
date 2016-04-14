class Game

  def initialize
    @game_in_progess = false

  end

  def start_game(client)
    if game_not_in_progress?(client)
      @game_in_progess = true
      @num_guesses = 0
      client.puts "Good luck!"
      @rand_number = rand(101)
    end
  end


  def game_not_in_progress?(client)
    if @game_in_progess
      client.puts "HTTP/1.1 403 Forbidden\n\r"
      client.puts "Game already in progress."
      return false
    else
      client.puts "HTTP/1.1 200 OK\n\r"
      return true
    end
  end

  def game(client, request_object, post_body)
    if request_object.request_hash["Verb"] == "POST"
      game_post_redirect(client)
    elsif request_object.request_hash["Verb"] == "GET"
      game_get(client,post_body)
    end
  end

  def game_post_redirect(client)
    status = "HTTP/1.1 302 Moved Temporarily\n"
    location = "Location: http://127.0.0.1:9292/game\n\r"
    client.puts status + location
  end

  def game_get(client,post_body)
    client.puts "HTTP/1.1 200 OK\n\r"
    user_guess = post_body.to_i
    if check_if_valid_guess(user_guess, post_body, client)
      @num_guesses += 1
      if user_guess < @rand_number
        client.puts "Your guess was #{user_guess}. That guess is too low. Try again! You've taken #{@num_guesses} guesses."
      elsif user_guess > @rand_number
        client.puts "Your guess was #{user_guess}. That guess is too high. Try again! You've taken #{@num_guesses} guesses."
      else
        @game_in_progess = false
        client.puts "WOOHOO You've won the game. Great guess! You took #{@num_guesses} guesses."
      end
    end
  end

  def check_if_valid_guess(user_guess, post_body, client)
    if post_body.empty? || user_guess < 0 || user_guess > 100
      client.puts "Sorry, that is not a valid guess. Please enter a number between 0 and 100."
      return false
    else
      return true
    end
  end

end
