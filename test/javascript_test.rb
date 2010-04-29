require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'harmony'

class JavascriptTest < Test::Unit::TestCase
  include JavascriptFeatures::Helper

  context 'an HTML page with a feature enabled' do
    setup do
      use_javascript_for :enabled_feature

      @page = Harmony::Page.new(%Q{
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>
            <script type="text/javascript">#{JavascriptFeatures::Compiler.compile(:package => 'javascript_test')}</script>
          </head>
          <body class="#{javascript_feature_classes}">
            <h1>Test page</h1>
          </body>
        </html>
      })
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
