Features.xhr = {
  init: function() {
    var xhr = jQuery.ajax({
      url: "/tests/_xhr",
      context: $(".xhr-target"),
      success: function(data) {
        $(".xhr-target").html(data);
      }
    });
  }
};
