# -*- encoding : utf-8 -*-
module JavascriptFeatures
  module Helper
    def self.included(controller)
      controller.helper_method :use_javascript_for, :use_javascript_for?, :javascript_feature_classes, :include_javascript_features if controller.respond_to? :helper_method
    end

    def use_javascript_for(*features)
      @javascript_features ||= []
      @javascript_features += features.map{|f| f.to_s.downcase }
      response.headers['X-JavascriptFeatures-Init'] = @javascript_features.uniq.join(' ') if request && request.xhr?
    end

    def use_javascript_for?(feature)
      @javascript_features.include?(feature.to_s.downcase)
    end

    def javascript_feature_classes
      (@javascript_features || []).uniq.map{ |feature| "with-js-#{feature}" }.join(" ")
    end

    def include_javascript_features(package = 'main')
      raise "Not Supported - Include Features using the asset pipeline"
    end

  end
end
