require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'rack/test'
require 'rack/javascript_features'

class RackTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    app = lambda{|env| [200, {"Content-Type" => "text/plain"}, ["all is well"]]}
    Rack::JavascriptFeatures.new(app)
  end

  context "when JavaScript isn't being requested" do
    setup do
      get '/some/other/path'
    end

    should 'delegate to the app' do
      assert_equal 200, last_response.status
      assert_equal 'all is well', last_response.body
    end
  end

  context "when the main JavaScript package is being requested" do
    setup do
      get '/javascripts/packaged/main.js'
    end

    should 'respond with the compiled JavaScript' do
      assert_equal 200, last_response.status
      assert_equal JavascriptFeatures::Compiler.compile, last_response.body
    end
  end

  context "when an alternative JavaScript package is being requested" do
    setup do
      get '/javascripts/packaged/alternative.js'
    end

    should 'respond with the compiled JavaScript' do
      assert_equal 200, last_response.status
      assert_equal JavascriptFeatures::Compiler.compile(:package => 'alternative'), last_response.body
    end
  end

  context "when an unknown JavaScript package is being requested" do
    setup do
      get '/javascripts/packaged/does_not_exist.js'
    end

    should 'delegate to the app' do
      assert_equal 200, last_response.status
      assert_equal 'all is well', last_response.body
    end
  end

end
