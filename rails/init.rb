require 'javascript_features'

ActionController::Base.send(:helper, JavascriptFeatures::Helper)
