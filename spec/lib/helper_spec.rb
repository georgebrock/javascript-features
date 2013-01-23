# -*- encoding : utf-8 -*-
require_relative '../../lib/javascript_features/helper'
include JavascriptFeatures::Helper

describe JavascriptFeatures::Helper do
  let(:request) { Request.new(:xhr => false) }

  describe 'Making a normal request' do
    let(:response) { Response.new }

    before(:each) do
      use_javascript_for "something"
    end

    it 'sets the corresponding body class' do
      javascript_feature_classes.should == 'with-js-something'
    end

    it 'should not modify the headers' do
      response.headers.should == {'Content-Type' => 'text/html'}
    end

    it 'can check if it is enabled' do
      use_javascript_for?('something').should be_true
      use_javascript_for?('something-else').should be_false
    end
  end

  describe 'Making a XHR request' do
    let(:request) { Request.new(:xhr => true) }
    let(:response) { Response.new }

    it 'modifies the headers' do
      use_javascript_for "something"
      use_javascript_for "something_else"
      response.headers.should == {'Content-Type' => 'text/html', 'X-JavascriptFeatures-Init' => 'something something_else'}
    end
  end

  describe 'if the same feature is enabled multiple times' do
    it 'only includes each class once' do
      use_javascript_for "something"
      use_javascript_for "something-else"
      use_javascript_for "something"
      javascript_feature_classes.should == "with-js-something with-js-something-else"
    end
  end

  describe 'passing several feature at one call' do
    it 'works properly' do
      use_javascript_for "something", "something-else"
      javascript_feature_classes.should == "with-js-something with-js-something-else"
    end
  end

  describe '#include_javascript_features' do
    it 'raises an error with a helpfull message' do
      expect { include_javascript_features }.to raise_error(RuntimeError)
    end
  end
end

class Request
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

class Response
  attr_accessor :headers
  def initialize
    @headers = {'Content-Type' => 'text/html'}
  end 
end 
