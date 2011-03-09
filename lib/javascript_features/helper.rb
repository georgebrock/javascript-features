module JavascriptFeatures
  module Helper

    def use_javascript_for(*features)
      @javascript_features ||= []
      @javascript_features += features.map(&:to_s)
      response.headers['X-JavascriptFeatures-Init'] = @javascript_features.uniq.join(' ') if request && request.xhr?
    end

    def javascript_feature_classes
      (@javascript_features || []).uniq.map{ |feature| "with-js-#{feature.downcase}" }.join(" ")
    end

    def include_javascript_features(package = 'main', options = {})
      query = Compiler.package_modified_time(package, options).to_i
      tag = %Q{<script type="text/javascript" src="/javascripts/packaged/#{package}.js?#{query}"></script>}
      if tag.respond_to?(:html_safe)
        tag.html_safe
      else
        tag
      end
    end

  end
end
