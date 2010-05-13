Features.global_load = {
  global_init: function(context) {
    context.find(".xhr-response").append("<span class=\"touched-by-global-init\"></span>");
  }
}
