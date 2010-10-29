require File.join(File.dirname(__FILE__), *%w[test_helper])

class HelperTest < Test::Unit::TestCase
  include JavascriptFeatures::Helper

  class TestRequest
    def initialize(options)
      @xhr = options[:xhr]
    end

    def xhr?
      @xhr
    end

    def xml_http_request?
      @xhr
    end
  end

  class TestResponse
    attr_accessor :headers
    def initialize
      @headers = {'Content-Type' => 'text/html'}
    end
  end

  context "when a JavaScript feature is enabled during a normal request" do
    setup do
      self.request = TestRequest.new(:xhr => false)
      self.response = TestResponse.new
      use_javascript_for "something"
    end

    should "set the corresponding body class" do
      assert_equal "with-js-something", javascript_feature_classes
    end

    should 'not modify the headers' do
      assert_equal({'Content-Type' => 'text/html'}, response.headers)
    end
  end

  context 'when a JavaScript feature is enabled during an XHR request' do
    setup do
      self.request = TestRequest.new(:xhr => true)
      self.response = TestResponse.new
      use_javascript_for "something"
      use_javascript_for "something_else"
    end

    should 'modify the headers' do
      assert_equal({'Content-Type' => 'text/html', 'X-JavascriptFeatures-Init' => 'something something_else'}, response.headers)
    end
  end

  context "when the same feature is enabled multiple times" do
    setup do
      use_javascript_for "something"
      use_javascript_for "something-else"
      use_javascript_for "something"
    end
    should "only include each class once" do
      assert_equal "with-js-something with-js-something-else", javascript_feature_classes
    end
  end

  context "when no features have been enabled" do
    should "not produce any classes" do
      assert_equal "", javascript_feature_classes
    end
  end
  
  should "allow to pass several features at one call" do
    use_javascript_for "something", "something-else"
    assert_equal "with-js-something with-js-something-else", javascript_feature_classes
  end

  context 'including the packaged JavaScript' do
    setup{ @script_tag = include_javascript_features }
    should 'write a script tag containing the correct URL' do
      assert_match %r{/javascripts/packaged/main\.js}, @script_tag
    end
  end

  context 'including an alternative JavaScript package' do
    setup{ @script_tag = include_javascript_features(:alternative) }
    should 'write a script tag containing the correct URL' do
      assert_match %r{/javascripts/packaged/alternative\.js}, @script_tag
    end
  end

  context 'including the packaged JavaScript after one of the files has been modified' do
    setup do
      @before_modified = include_javascript_features
      FileUtils.touch File.join(Rails.root, %w[ public javascripts main my_feature.js ])
      @after_modified = include_javascript_features
    end

    should 'include different query strings to avoid caching' do
      assert @before_modified != @after_modified, "Expected #{@before_modified.inspect} and #{@after_modified.inspect} to be different"
    end
  end
end
