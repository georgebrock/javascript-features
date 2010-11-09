module JavascriptFeatures
  autoload :Compiler, 'javascript_features/compiler'
  autoload :Helper, 'javascript_features/helper'
  autoload :TestCase, 'javascript_features/test_case'
end

ActionController::Base.send(:helper, JavascriptFeatures::Helper) if defined?(ActionController)
