
$ =>
  new Firehose.Consumer(
    uri: @poll_uri
    message: (json) ->
      window.location.reload()
  ).connect() if @poll_uri
