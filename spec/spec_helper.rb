$:.unshift File.expand_path("../..", __FILE__)
require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require "cover_my_meds"
require 'rspec'
require 'rspec/junklet'
require 'rest-client'
require 'webmock'
require 'webmock/rspec'
require 'pry'
require 'support/webmock_strict'
require 'securerandom'
require 'dotenv'
Dotenv.load

RSpec.configure do |config|
  config.color = true
  config.filter_run_excluding :integration => true
end

def stub_get(path, fixture_name)
  stub_request(:get, api_url(path)).
    with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
    to_return( status:  200, body:    fixture(fixture_name), headers: {})
end

def stub_post(path, fixture_name)
  stub_request(:post, api_url(path)).
    with(:body => {"accept"=>"json"},
         :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'11', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => fixture(fixture_name), :headers => {})
end

def stub_create_new_request(path, fixture_name, data = nil)
  stub_request(:post, api_url(path)).
    with(:body => data, :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'1995', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => fixture(fixture_name), :headers => {})
end

def stub_delete(path)
  stub_request(:delete, api_url(path)).
    with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
    to_return(:status => 204, :body => '', :headers => {})
end


def fixture_path(file=nil)
  path = File.expand_path("../fixtures", __FILE__)
  file.nil? ? path : File.join(path, file)
end

def fixture(file)
  File.read(fixture_path(file))
end

def api_url(path)
  "#{CoverMyMeds::ApiRequest.api_url}#{path}"
end
