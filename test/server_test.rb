require "./lib/server"
require "./test/test_helper"

class ServerTest < Minitest::Test

  def test_it_has_200_status_response_home_page
    response = Faraday.get('http://127.0.0.1:9292/')
    assert_equal 200, response.status
  end

  def test_it_has_200_status_response_on_hello
    response = Faraday.get('http://127.0.0.1:9292/hello')
    assert_equal 200, response.status
  end

  def test_it_has_200_status_response_on_datetime
    response = Faraday.get('http://127.0.0.1:9292/datetime')
    assert_equal 200, response.status
  end

  def test_it_has_200_status_response_on_shutdown
    skip
    response = Faraday.get('http://127.0.0.1:9292/shutdown')
    assert_equal 200, response.status
  end

  def test_hello_world_body_outputs_string
    response = Faraday.get('http://127.0.0.1:9292/hello')
    assert response.body.include?("Hello")
  end

  def test_datetime_body_outputs_year
    response = Faraday.get('http://127.0.0.1:9292/datetime')

    year = Time.new.year.to_s

    assert response.body.include?(year)
  end

  def test_it_can_parse_a_request
    response = Faraday.get('http://127.0.0.1:9292/')

    assert response.body.include?("Port")
    assert response.body.include?("9292")
    assert response.body.include?("Host")
    assert response.body.include?("Path")
    assert response.body.include?("Accept")
  end

  def test_it_can_find_a_word
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=common')
    assert response.body.include?("COMMON is a known word")
  end

  def test_it_knows_when_word_is_not_a_real_word
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=asdf')
    assert response.body.include?("ASDF is not a known word")
  end

  def test_it_can_handle_all_upercase_letters
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=COMMON')
    assert response.body.include?("COMMON is a known word")
  end

  def test_it_can_handle_word_with_upper_and_lower_case
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=cOmMoN')
    assert response.body.include?("COMMON is a known word")
  end

  def test_it_can_handle_letters_or_numbers
    response = Faraday.get('http://127.0.0.1:9292/word_search?word=co11on')
    assert response.body.include?("CO11ON is not a known word")
  end

  def test_it_can_start_game_and_know_if_started
    conn = Faraday.new(:url => 'http://127.0.0.1:9292')
    response1 = conn.post '/start_game'
    response2 = conn.post '/start_game'

    assert_equal "Good luck!\n", response1.body
    assert_equal "Game already in progress.\n", response2.body
    assert_equal 403, response2.status
  end

  def test_error_404_for_unknown_page
    response = Faraday.get('http://127.0.0.1:9292/ssssss')
    assert_equal 404, response.status
  end

  def test_can_get_error_status
    response = Faraday.get('http://127.0.0.1:9292/force_error')
    assert_equal 500, response.status
  end

end
