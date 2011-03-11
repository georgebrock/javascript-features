var Features = {};

jQuery(function($) {

  var init = function(context, use_feature) {
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

  $("body").ajaxComplete(function(event, xhr, options) {
    if(xhr.readyState !== 4){ return; }
    var init_features = (xhr.getResponseHeader("X-JavascriptFeatures-Init") || "").toLowerCase().split(" ");
    var context = $(options.context || document);
    init(context, function(feature) {
      for(var i = 0; i < init_features.length; i++) {
        if(init_features[i] === feature.toLowerCase()) {
          return true;
        }
      }
    });
  });

  init($(document), function(feature) {
    return $("body").hasClass("with-js-" + feature.toLowerCase());
  });
});
