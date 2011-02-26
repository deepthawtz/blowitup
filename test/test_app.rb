require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

class TestBlowitup < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  alias_method :response, :last_response

  def app
    Blowitup::App.new
  end

  def test_homepage
    get "/"
    assert response.ok?
  end

  def test_post_message
    post "/", :message => "aw yeah"
    assert_equal 200, response.status
  end

  def test_post_empty_message
    post "/", :message => "    "
    assert_equal 400, response.status
  end
end
