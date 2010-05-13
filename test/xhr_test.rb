require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'harmony'

class XhrTest < Test::Unit::TestCase
  include JavascriptFeatures::Helper

  context 'an HTML page with a feature enabled' do
    setup do
      use_javascript_for :xhr

      index_html = %%
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>
            #{include_javascript_features('xhr_test')}
          </head>
          <body class="#{javascript_feature_classes}">
            <h1>Test page</h1>
            <div class="xhr-target"></div>
            <div class="unrelated xhr-response">Unrelated</div>
          </body>
        </html>
      %

      xhr_html = {
        :body => '<p class="real xhr-response">Hello, world</p>',
        :headers => {'X-JavascriptFeatures-Init' => 'load'}
      }

      javascript_server_config = {:BindAddress => '0.0.0.0', :Port => 8076}
      @javascript_server = ::WEBrick::HTTPServer.new(javascript_server_config)
      @javascript_server.mount('/', TestServlet, '/index.html' => index_html, '/xhr' => xhr_html)
      Thread.new{ @javascript_server.start }

      @page = Harmony::Page.fetch("http://#{javascript_server_config[:BindAddress]}:#{javascript_server_config[:Port]}/index.html")
      Harmony::Page::Window::BASE_RUNTIME.wait
    end

    teardown do
      @javascript_server.shutdown
    end

    should 'complete the XHR request' do
      assert_equal 1, @page.execute_js('jQuery(".real.xhr-response").length')
    end

    should 'initialise the feature required by the XHR content' do
      assert_match(/touched-by-load/, @page.execute_js('jQuery(".real.xhr-response").attr("class")'))
    end

    should 'limit the scope of the feature required by the XHR content to the XHR content itself' do
      assert_no_match(/touched-by-load/, @page.execute_js('jQuery(".unrelated.xhr-response").attr("class")'))
    end

    should 're-run global initialisation code when the XHR completes, limited to the scope of the XHR content' do
      assert_equal 1, @page.execute_js('jQuery(".real.xhr-response .touched-by-global-init").length')
      assert_equal 1, @page.execute_js('jQuery(".unrelated.xhr-response .touched-by-global-init").length')
    end

  end

end
