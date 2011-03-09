require File.join(File.dirname(__FILE__), *%w[test_helper])

class JqueryInclusionTest < JavascriptFeatures::TestCase
  context 'when not requesting jQuery' do
    uses_html do
      %%
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>
            #{include_javascript_features(feature_package)}
          </head>
          <body>
          </body>
        </html>
      %
    end

    should 'not include jQuery' do
      assert_equal 'undefined', execute_js('typeof(jQuery)')
    end
  end

  context 'when requesting jQuery' do
    uses_html do
      %%
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>
            #{include_javascript_features(feature_package, :jquery => true)}
          </head>
          <body>
          </body>
        </html>
      %
    end

    should 'include jQuery' do
      assert_not_equal 'undefined', execute_js('typeof(jQuery)')
    end
  end
end
