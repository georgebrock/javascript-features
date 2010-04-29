require 'javascript_features'

module Rack
  class JavascriptFeatures

    def initialize(app)
      @app = app
    end

    def call(env)
      if javascript = get_javascript(env)
        [200, {"Content-Type" => "text/javascript", "Cache-Control" => "private"}, [javascript]]
      else
        @app.call(env)
      end
    end

  private

    def get_javascript(env)
      relevant_url = Rack::Request.new(env).path =~ %r{javascripts/packaged/([^/]+)\.js}
      package_name = relevant_url && $1
      real_package = package_name && ::File.exists?(::File.join(Rails.root, 'public', 'javascripts', package_name))
      return false unless relevant_url and real_package
      ::JavascriptFeatures::Compiler.compile(:package => package_name)
    end

  end
end
