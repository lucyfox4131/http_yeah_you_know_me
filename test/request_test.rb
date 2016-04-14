require "./lib/request"
require "./test/test_helper"

class RequestTest < Minitest::Test

  def setup
    @request = Request.new

    @request_lines = [
      "GET / HTTP/1.1",
      "Host: 127.0.0.1:9292",
      "Connection: keep-alive",
      "Cache-Control: no-cache",
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
      "Postman-Token: 95b22833-429f-0e7b-06e3-d37b6487227f",
      "Accept: */*",
      "Accept-Encoding: gzip, deflate, sdch",
      "Accept-Language: en-US,en;q=0.8,ko;q=0.6"
    ]

    @hash = {
      "Verb"=>"GET",
      "Path"=>"/",
      "Protocol"=>"HTTP/1.1",
      "Host"=>"127.0.0.1",
      "Port"=>"9292",
      "Connection"=>"keep-alive",
      "Cache-Control"=>"no-cache",
      "User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
      "Postman-Token"=>"95b22833-429f-0e7b-06e3-d37b6487227f",
      "Accept"=>"*/*",
      "Accept-Encoding"=>"gzip, deflate, sdch",
      "Accept-Language"=>"en-US,en;q=0.8,ko;q=0.6"
    }


    @formatted_lines = "Verb: GET\n"\
    "Path: /\n"\
    "Protocol: HTTP/1.1\n"\
    "Host: 127.0.0.1\n"\
    "Port: 9292\n"\
    "Origin: 127.0.0.1\n"\
    "Accept: */*\n"

  end

  def test_it_can_create_new_instance_of_request_class
    assert_equal Request, @request.class
  end

  def test_it_can_parse_request_into_hash
    assert_equal Hash, @request.parse_request(@request_lines).class
  end

  def test_it_can_parse_request_into_desired_hash
    assert_equal @hash, @request.parse_request(@request_lines)
  end

  def test_it_can_parse_and_find_any_desired_element_of_request
    assert @request.parse_request(@request_lines).include?("Verb")
    assert @request.parse_request(@request_lines).include?("Path")
    assert @request.parse_request(@request_lines).include?("Protocol")
    assert @request.parse_request(@request_lines).include?("Host")
    assert @request.parse_request(@request_lines).include?("Port")
    assert @request.parse_request(@request_lines).include?("Accept")
  end

  def test_it_can_format_as_a_string
    @request.parse_request(@request_lines)
    assert_equal String, @request.formatted_diagnostic.class
  end

  def test_it_can_format_a_request_for_server_response=
    @request.parse_request(@request_lines)
    assert_equal @formatted_lines, @request.formatted_diagnostic
  end

  def test_it_formats_and_does_not_include_undesired_information
    @request.parse_request(@request_lines)
    refute @request.formatted_diagnostic.include?("Connection")
    refute @request.formatted_diagnostic.include?("Cache-Control")
    refute @request.formatted_diagnostic.include?("User-Agent")
    refute @request.formatted_diagnostic.include?("Accept-Encoding")
    refute @request.formatted_diagnostic.include?("Accept-Language")
  end

end
