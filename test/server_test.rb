require "minitest/autorun"
require "minitest/pride"
require "./server"
require "faraday"
require "pry"

class ServerTest < Minitest::Test

  def test_it_can_have_a_server
    response = Faraday.get('http://127.0.0.1:9292')
    binding.pry
    assert response.success?
  end

end
