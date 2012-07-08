$('document').ready =>
  $("#group_invitation").on 'change', (event)->
    checked = $(this).prop('checked')
    if (!checked && !confirm("If you re-enable, there will be a new shortened UR. Are you sure you want to disable?"))
      $(this).prop('checked', true)
      return false
    poll_id = $("#poll_id").val()
    owner_key = window.location.search.substr(11)
    poll_data = { poll_id: poll_id, use_invitation_key : checked, owner_key : owner_key }
    $.ajax "/polls/#{poll_id}.json", type: 'PUT', data: poll_data, success: (data)->
      $("#group_invitation_link").val(data.group_link)
      $("#group_invitation_link").prop('disabled', !checked)
      $("#shortened_group_invitation_link").val(data.shortened_group_link)
      $("#shortened_group_invitation_link").prop('disabled', !checked)
      if checked
        GreenEggs.enableClippy()
      else
        GreenEggs.disableClippy()

  GreenEggs.enableClippy = ->
    $(".copy-to-clipboard, clippable").removeClass("hidden")
    ZeroClipboard.setMoviePath( '/ZeroClipboard10.swf' )
    clip = null
    GreenEggs.clipClients = []

    for clippable in ["short-link", "long-link"]
      clip = new ZeroClipboard.Client()
      elements = $(".copy-to-clipboard.#{clippable} div")
      if elements.length > 0
        element = elements[0]
        clip.glue(element)
        clip.setText($("input.#{clippable}").val())
        clip.addEventListener( 'onComplete', (options, value) =>
          $(options.domElement).closest("table").find("span.copied").addClass("hidden")
          $(options.domElement).closest("tr").find("span.copied").removeClass("hidden")
        )
        $(window).resize ->
          clip.reposition()
        GreenEggs.clipClients.push clip

  GreenEggs.disableClippy = ->
    $(".copy-to-clipboard, .copied, .clippable").addClass("hidden")

  unless $("#shortened_group_invitation_link").prop('disabled') == true
    GreenEggs.enableClippy()
