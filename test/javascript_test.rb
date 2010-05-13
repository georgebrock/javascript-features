require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'harmony'
require 'webrick'

class JavascriptTest < Test::Unit::TestCase
  include JavascriptFeatures::Helper

  context 'an HTML page with a feature enabled' do
    setup do
      use_javascript_for :enabled_feature

      html = %%
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>
            #{include_javascript_features('javascript_test')}
          </head>
          <body class="#{javascript_feature_classes}">
            <h1>Test page</h1>
          </body>
        </html>
      %

      javascript_server_config = {:BindAddress => '0.0.0.0', :Port => 8076}
      @javascript_server = ::WEBrick::HTTPServer.new(javascript_server_config)
      @javascript_server.mount('/', TestServlet, '/index.html' => html)
      Thread.new{ @javascript_server.start }

      @page = Harmony::Page.fetch("http://#{javascript_server_config[:BindAddress]}:#{javascript_server_config[:Port]}/index.html")
      Harmony::Page::Window::BASE_RUNTIME.wait
    end

    teardown do
      @javascript_server.shutdown
    end

    should 'initialise the enabled feature' do
      assert_equal 1, @page.execute_js('jQuery("div.enabled_feature").length')
    end

    should 'not initialise the disabled feature' do
      assert_equal 0, @page.execute_js('jQuery("div.disabled_feature").length')
    end

    should 'initialise the global feature' do
      assert_equal 1, @page.execute_js('jQuery("div.global_feature").length')
    end

  end

end
