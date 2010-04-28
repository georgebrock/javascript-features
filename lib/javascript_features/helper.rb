module JavascriptFeatures
  module Helper

    def use_javascript_for(feature)
      @javascript_features ||= []
      @javascript_features << feature.to_s
    end

    def javascript_feature_classes
      (@javascript_features || []).uniq.map{ |feature| "with-js-#{feature.downcase}" }.join(" ")
    end

  end
end
