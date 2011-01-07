require File.join(File.dirname(__FILE__), *%w[test_helper])

class TestCaseTest < JavascriptFeatures::TestCase
  uses_html_body{ '<div class="foo"></div>' }

  should 'have some HTML' do
    assert_not_nil @html
  end

  should 'include the main JS package' do
    assert_match %r{<script [^>]*src="/javascripts/packaged/main\.js(\?\d+)?"}, @html
  end

  should 'take the enabled feature name from the class name' do
    assert_match %r{<body class="with-js-testcase">}, @html
  end

  should 'create a Harmony::Page for the HTML' do
    assert_not_nil @page
  end

  should 'load the JavaScript in the Harmony::Page' do
    assert_equal 'object', @page.execute_js('typeof Features')
  end

  should 'provide a method of executing JS without knowing about the @page variable' do
    assert_equal 'object', execute_js('typeof Features')
  end

  should 'provide a custom assertion for counting DOM nodes' do
    assert_nothing_raised{ assert_selector_count(1, 'div.foo') }
    assert_raises(Test::Unit::AssertionFailedError){ assert_selector_count(2, 'div.foo') }
  end

end

class CustomFeatureTest < JavascriptFeatures::TestCase
  uses_html_body{ '<div class="foo"></div>' }
  tests_feature 'foo'

  should 'use the custom feature instead of deriving the feature from the class name' do
    assert_match %r{<body class="with-js-foo">}, @html
  end
end

class MultipleFeatureTest < JavascriptFeatures::TestCase
  uses_html_body{ '<div class="foo"></div>' }
  tests_feature 'foo', 'bar', 'baz'

  should 'use all of the custom features' do
    ['foo', 'bar', 'baz'].each do |feature|
      assert execute_js("jQuery('body').hasClass('with-js-#{feature}')")
    end
  end

  should 'not use the feature name derived from the class name' do
    assert execute_js('!jQuery("body").hasClass("with-js-mulitplefeature")')
  end
end
