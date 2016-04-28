**HTTP Yeah You Know Me**

**Purpose:**

The purpose of this project was to create a local HTTP server that implemented and demonstrated understanding of the request/response cycle

**Cloning:**

git clone https://github.com/lucyfox4131/http_yeah_you_know_me.git

**File Structure:**


*lib*
  - game.rb
  - request.rb
  - response.rb
  - server.rb
  - system_error.rb

*test*
  - request_test.rb
  - server_test.rb
  - test_helper.rb

**Usage:**

After cloning the repo you must first start the server by running `ruby server.rb`. You can use postman, or a browser to run server requests. You can use `http://127.0.0.1:9292` using port `9292` locally. The server has several paths available. If you chose to start out with no path designated the server will output diagnostics of the GET request. Alternatively, you can visit one of the many paths implemented.

* To see Hello World printed out to the screen including a counter of the amount of requests on that page you can type  `http://127.0.0.1:9292/hello`.
* To see the current date and time `/datetime`.
* You can shutdown the server by using  `/shutdown`
* You can see if a word exists in the dictionary by using and entering your word as a parameter  `/word_search`
* You may also modify your wordsearch to output in JSON by using the `HTTP-Accept` and entering `application/json`.
* Finally, you can play a game guessing a number between 1-100. Send a `POST` request to `/start_game` and to guess a number send a `POST` request to `/game` with a number guess in the body of the request.
* If you want to see how the server handles errors you can visit the `/force_error` to show the System handling an error.
