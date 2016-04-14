class Response

  def initialize
    @count_hello_requests = 0
  end

  def hello_world(client, request_object)
    @count_hello_requests+=1
    client.puts "Hello World (#{@count_hello_requests})\nCurrent request:\n#{request_object.formatted_diagnostic}"
  end

  def datetime(client, request_object)
    client.puts "#{Time.now.strftime('%r:%M%p on %A, %B %e, %Y')}\nCurrent request:\n#{request_object.formatted_diagnostic}"
  end

  def word_search(client, request_object)
    words = File.readlines('/usr/share/dict/words').map {|x| x.chomp.downcase}
    test_word = request_object.request_hash["Path"][/word=.*/][5..-1]
    if words.include?(test_word.downcase)
      client.puts "#{test_word.upcase} is a known word \nCurrent request:\n#{request_object.formatted_diagnostic}"
    else
      client.puts "#{test_word.upcase} is not a known word \nCurrent request:\n#{request_object.formatted_diagnostic}"
    end
  end

end
