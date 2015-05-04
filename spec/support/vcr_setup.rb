require 'vcr'
VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/support/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end
