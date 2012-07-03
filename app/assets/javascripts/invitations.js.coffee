$ =>
  $("#group_invitation").on 'change', (event)->
    checked = $(this).prop('checked')
    if (!checked && !confirm("If you re-enable, there will be a new code. Are you sure you want to disable?"))
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
