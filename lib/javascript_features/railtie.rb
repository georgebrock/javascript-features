# -*- encoding : utf-8 -*-
require 'javascript_features/helper'
module JavascriptFeatures
  class Railtie < Rails::Railtie
    initializer "javascript_features.helper" do
      ActionView::Base.send :include, Helper
    end
  end
end
