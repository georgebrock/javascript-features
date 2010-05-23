require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'harmony'

class XhrTest < JavascriptFeatures::TestCase

  uses_html_body{%%
    <h1>Test page</h1>
    <div class="xhr-target"></div>
    <div class="unrelated xhr-response">Unrelated</div>
  %}

  uses_feature_package :xhr_test

  stubs_http_request('/xhr', :body => '<p class="real xhr-response">Hello, world</p>', :headers => {'X-JavascriptFeatures-Init' => 'load'})

  should 'complete the XHR request' do
    assert_selector_count 1, '.real.xhr-response'
  end

  should 'initialise the feature required by the XHR content' do
    assert_match(/touched-by-load/, execute_js('jQuery(".real.xhr-response").attr("class")'))
  end

  should 'limit the scope of the feature required by the XHR content to the XHR content itself' do
    assert_no_match(/touched-by-load/, execute_js('jQuery(".unrelated.xhr-response").attr("class")'))
  end

  should 're-run global initialisation code when the XHR completes, limited to the scope of the XHR content' do
    assert_selector_count 1, '.real.xhr-response .touched-by-global-init'
    assert_selector_count 1, '.unrelated.xhr-response .touched-by-global-init'
  end

end
