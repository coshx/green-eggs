module FirehoseServer

  def self.uri
    @uri ||= ENV['firehose_uri'] || '//localhost:7474'
  end

end
