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
      %Q{<script type="text/javascript" src="/javascripts/packaged/#{package}.js"></script>}
    end

  end
end
