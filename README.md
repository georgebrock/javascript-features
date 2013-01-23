# JavaScript Features #

Features is an opinionated framework for structured, unobtrusive, jQuery-based JavaScript in Ruby on Rails apps. If you follow a few conventions, lots of things will "just work", just like they do in Rails.

## Using it ##

1.  Add the gem to your Gemfile: `gem 'javascript_features'`
2.  Include the javascript_feature_classes helper in your layout, e.g. in ERB:

        <html>
          <head>
            …
          </head>
          <body class="<%= javascript_feature_classes %>">
            …
          </body>
        </html>
3.  Use the asset pipeline to include Jquery and JavaScript Features,
    e.g.

        //= require jquery
        //= require javascript_features

4.  Add any jQuery plugins you want to use. They can live anywhere you
    want, but `vendor/assets/javascripts` or `lib/assets/javascripts`
are good choices.  Make sure you include you plugins in your manifest.
5.  Start writing JavaScript features. They can live anywhere but
    `app/assets/javascripts` is a good place.

        Features.my_feature = {
          init: function() {
            // This code will be run on pages that
            // explicitly activate this feature
          },
          global_init: function() {
            // This code will be run on every page
          }
        };

6.  Within your templates, activate specific features by called `<% use_javascript_for :my_feature %>` to make sure the `init` function is called. You can also specify several features at once: `<% use_javascript_for :first_feature, :second_feature %>`.

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

    When the init function is called on DOM ready, the whole document will be passed as context.

## Testing ##

Javascript Features is tested with capybara and poltergeist. To run the
tests you may need to install PhantomJS, on a mac `brew install
phantomjs` will do the trick. There are Binary packages for Windows and Linux
at [phantom.js.org](http://phantomjs.org)

## Upgrading ##
If you are upgrading from JavaScript Features 1.0.3 you will need to
move your JavaScripts to `/app/assets` so the asset pipeline can package
them. The `include_javascript_features` helper will now raise an
exception to remind you to use the asset pipeline and include your
javascript with `javascript_include_tag`.

## License ##

You may use, copy and redistribute this library [under the same terms as Ruby](http://www.ruby-lang.org/en/LICENSE.txt) itself or under the [MIT license](http://creativecommons.org/licenses/MIT/).
