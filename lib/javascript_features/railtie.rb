# -*- encoding : utf-8 -*-
require 'javascript_features/helper'
module JavascriptFeatures
  class Railtie < Rails::Railtie
    initializer "javascript_features.helper" do
      ActionController::Base.send :include, Helper
      ActionView::Base.send :alias_method, :include_javascript_features, :javascript_include_tag
    end
  end
end
