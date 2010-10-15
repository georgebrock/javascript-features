module JavascriptFeatures
  module Helper

    def use_javascript_for(feature)
      @javascript_features ||= []
      @javascript_features << feature.to_s
      response.headers['X-JavascriptFeatures-Init'] = @javascript_features.uniq.join(' ') if request && request.xhr?
    end

    def javascript_feature_classes
      (@javascript_features || []).uniq.map{ |feature| "with-js-#{feature.downcase}" }.join(" ")
    end

    def include_javascript_features(package = 'main')
      query = Compiler.package_modified_time(package).to_i
      %Q{<script type="text/javascript" src="/javascripts/packaged/#{package}.js?#{query}"></script>}
    end

  end
end
