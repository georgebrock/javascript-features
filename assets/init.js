var Features = {};

Features.init = function(context, use_feature) {
  for(var key in Features) {
    if(Features.hasOwnProperty(key)) {
      if(typeof Features[key].global_init === "function") {
        Features[key].global_init(context);
      }
      if(typeof Features[key].init === "function" && use_feature(key)) {
        Features[key].init(context);
      }
    }
  }
};

jQuery(function($) {
  $("body").ajaxComplete(function(event, xhr, options) {
    var init_features = (xhr.getResponseHeader("X-JavascriptFeatures-Init") || "").toLowerCase().split(" ");
    var context = $(options.context || document);
    Features.init(context, function(feature) {
      for(var i = 0; i < init_features.length; i++) {
        if(init_features[i] === feature.toLowerCase()) {
          return true;
        }
      }
    });
  });

  Features.init($(document), function(feature) {
    return $("body").hasClass("with-js-" + feature.toLowerCase());
  });
});
