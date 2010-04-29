var Features = {};

jQuery(function($) {
  for(key in Features) {
    if(Features.hasOwnProperty(key)) {
      if(typeof Features[key].global_init === "function") {
        Features[key].global_init();
      }
      if(typeof Features[key].init === "function" && $("body").hasClass("with-js-" + key.toLowerCase())) {
        Features[key].init();
      }
    }
  }
});
