require 'javascript_features'

module Rack
  class JavascriptFeatures

    DEFAULT_OPTIONS = {:minify => true}

    def initialize(app, options = {})
      @app = app
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def call(env)
      request = Rack::Request.new(env)

      if package = package_for_path(request.path)
        etag = package_etag(package)
        if etag == env['HTTP_IF_NONE_MATCH']
          [304, {}, []]
        else
          javascript = package_javascript(package)
          [200, {"Content-Type" => "text/javascript", "Cache-Control" => "private", "ETag" => etag}, [javascript]]
        end
      else
        @app.call(env)
      end
    end

  private

    def package_for_path(path)
      relevant_url = path =~ %r{javascripts/packaged/([^/]+)\.js}
      package_name = relevant_url && $1
      real_package = package_name && ::File.exists?(::File.join(Rails.root, 'public', 'javascripts', package_name))
      real_package && package_name
    end

    def package_etag(package_name)
      mtime = ::JavascriptFeatures::Compiler.package_modified_time(package_name)
      etag = Digest::MD5.hexdigest("#{package_name}/#{mtime.to_i}")
    end

    def package_javascript(package_name)
      ::JavascriptFeatures::Compiler.compile(:package => package_name, :minify => @options[:minify])
    end

  end
end
