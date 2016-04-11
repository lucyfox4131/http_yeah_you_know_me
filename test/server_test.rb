require "./lib/server"
require "./test/test_helper"

class ServerTest < Minitest::Test

  def test_it_can_have_a_server
    response = Faraday.get('http://127.0.0.1:9292')
    assert response.success?
  end

end
