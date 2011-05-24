require 'active_support/test_case'

begin
  require 'harmony'
rescue LoadError
  raise 'You must gem install harmony to use javascript-features test case'
end

module JavascriptFeatures
  class TestCase < ::ActiveSupport::TestCase
    extend JavascriptFeatures::Helper

    autoload :Servlet, 'javascript_features/test_case/servlet'

    class << self
      def request
        nil
      end

      def uses_feature_package(package)
        @feature_package = package
      end

      def feature_package
        @feature_package ||= 'main'
      end

      def tests_feature(*names)
        @feature_names = names
      end

      def feature_names
        @feature_names ||= [self.name.downcase.sub(/test$/, '')]
      end

      def stubs_http_request(url, options)
        @server_pages = server_pages.merge(url => options)
      end

      def server_pages
        @server_pages ||= {}
      end

      def uses_html(&block)
        define_method(:setup) do
          self.class.feature_names.each{ |f| self.class.use_javascript_for f }
          @html = yield.strip

          server_config = {:BindAddress => '0.0.0.0', :Port => 8076, :AccessLog => [], :Logger => WEBrick::Log::new('/dev/null', 7)}
          @server = ::WEBrick::HTTPServer.new(server_config)
          pages = self.class.server_pages.merge(
                    '/index.html' => @html,
                    '/jquery.js' => File.read(File.expand_path('../../../assets/jquery.js', __FILE__))
                  )
          @server.mount('/', JavascriptFeatures::TestCase::Servlet, pages)
          Thread.new{ @server.start }

          @page = Harmony::Page.fetch("http://#{server_config[:BindAddress]}:#{server_config[:Port]}/index.html")
          Harmony::Page::Window::BASE_RUNTIME.wait
        end

        define_method(:teardown) do
          @server.shutdown
        end
      end

      def uses_html_body
        uses_html do
          %%
            <!DOCTYPE html>
            <html lang="en">
              <head>
                <title>Test page</title>
              </head>
              <body class="#{javascript_feature_classes}">
                #{yield.strip}

                <script src='/jquery.js'></script>
                #{include_javascript_features(feature_package)}
              </body>
            </html>
          %
        end
      end
    end

    def execute_js(*args)
      @page.execute_js(*args)
    end

    def assert_selector_count(expected_count, selector)
      real_count = execute_js("jQuery(#{selector.to_json}).length")
      assert_equal expected_count, real_count, "Expected #{expected_count} elements matching selector #{selector}, found #{real_count}"
    end
  end
end
