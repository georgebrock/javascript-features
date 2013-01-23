Features.xhr = {
  init: function() {
    var xhr = jQuery.ajax({
      url: "/xhr",
      context: $(".xhr-target"),
      success: function(data) {
        $(".xhr-target").html(data);
      }
    });
  }
};
