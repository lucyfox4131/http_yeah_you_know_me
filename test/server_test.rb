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
end
