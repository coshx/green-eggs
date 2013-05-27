$ ->
  $(window).resize ->
    if $("html").height() + $($(".green-controls").filter(":visible")[0]).height() > $(window).height()
      $(".green-controls").css("position", "static")
    else
      $(".green-controls").css("position", "absolute")

