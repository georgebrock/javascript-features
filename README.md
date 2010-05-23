# JavaScript Features #

Features is an opinionated framework for structured, unobtrusive, jQuery-based JavaScript in Ruby on Rails apps. If you follow a few conventions, lots of things will "just work", just like they do in Rails.

## Using it ##

1.  Install the gem: `gem install javascript_features`
2.  Include the JavaScript in your layout, e.g. in ERB:

        <html>
          <head>
            <%= include_javascript_features %>
          </head>
          <body class="<%= javascript_feature_classes %>">
            …
          </body>
        </html>

3.  Add any jQuery plugins you want to use. These should live in `/public/javascripts/lib`
4.  Start writing JavaScript features. Each should have its own file in `/public/javascripts/main` and should look like this:

        Features.my_feature = {
          init: function() {
            // This code will be run on pages that
            // explicitly activate this feature
          },
          global_init: function() {
            // This code will be run on every page
          }
        };

5.  Within your templates, activate specific features by called `<% use_javascript_for :my_feature %>` to make sure the `init` function is called.

## Working with AJAX ##

If you load some HTML via AJAX and inject it into your page, the relevant JavaScript features will still be initialised for the asynchronously loaded content, as long as the call to `use_javascript_for` is part of the view or partial that is rendered in response to the AJAX request. However, to make this work correctly you need to make sure that the same bit of markup doesn't get enhanced twice.  There are two ways to do this:

1.  ### Write defensive `init` functions ###

    You can add a class to the markup you are enhancing, and only enhance markup that doesn't already have that class. For example:
    
        Features.my_feature = {
          init: function() {
            // Find all elements with class "my_feature" but not class "enhanced"
            $(".my_feature:not(.enhanced)").each(function() {
              // Set up your feature…
              // Make sure this element isn't enhanced again
              $(this).addClass("enhanced");
            });
          }
        };

2.  ### Use jQuery's AJAX context option ###

    If you take this approach you will need to set a context when you make AJAX requests:

        jQuery.ajax({
          url: "/some/path",
          context: $("div#ajax_target"),
          success: function(data) {
            $(this).html(data);
          }
        });

    The context will then be passed to your init functions:

        Features.my_feature = {
          init: function(context) {
            context.find(".my_feature").each(function() {
              // Set up your feature…
            });
          }
        };

## Testing ##

There is some testing support built into Features.  You can use the `JavascriptFeatures::TestCase` class as the basis of JavaScript tests. It's farily basic at the moment, but should provide enough to get started.  The main features are demonstrated in this example test case:

    class WidgetTest < JavascriptFeatures::TestCase
    
      # Write some HTML for the test case to work with, this is required.
      uses_html_body{ '<div class="widget"></div>' }
      
      # Optionally specify which folder features should be loaded from. The default is 'main'
      uses_feature_package 'my_features'
      
      # Optionally specify which feature(s) to initialise. The default is extracted from the name of
      # the test class, e.g. 'WidgetTest' would become 'widget'
      tests_feature 'feature'
      
      # Use stubs_http_request to test features that use AJAX
      stubs_http_request '/foo', :body => 'Some words', :headers => {'Content-Type' => 'text/plain'}
      
      # Run JavaScript using execute_js
      def test_should_update_the_contents_of_the_widget
        assert_equal 'hello', execute_js(' jQuery("widget").text() ')
      end
      
      # Count elements in the page using assert_selector_count
      def test_should_add_the_enhanced_class_to_the_widget
        assert_selector_count 1, '.widget.enhanced'
      end
      
    end

## Other bits and bobs ##

*  You can created multiple sets of features.  Just put them in different sub-folders and then pass the name of the folder to `include_javascript_features`, e.g. you can include the features from `/public/javascripts/foo` by calling `include_javascript_features('foo')`

## License ##

You may use, copy and redistribute this library [under the same terms as Ruby](http://www.ruby-lang.org/en/LICENSE.txt) itself or under the [MIT license](http://creativecommons.org/licenses/MIT/).
