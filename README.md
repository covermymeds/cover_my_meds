# CoverMyMeds API

CoverMyApi is a gem that provides a Ruby client for api.covermymeds.com

[![Code Climate](https://codeclimate.com/github/covermymeds/cover_my_meds/badges/gpa.svg)](https://codeclimate.com/github/covermymeds/cover_my_meds)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cover_my_meds'
```

And then execute:

```
bundle
```

*For general API documentation see: https://developers.covermymeds.com/ehr-api.html*

## Contributing

Fork the repo, make changes, and submit a pull request.

## Usage

You can use the CoverMyApi client to retrieve drugs, forms, pa requests, access tokens and create requests.

```ruby
require 'cover_my_meds'  # not needed in a rails app
```

## Getting Started

### Default Client

```ruby
CoverMyMeds.default_client
```

This will set up a new client with a default host of
`https://api.covermymeds.com` and all the default paths. It will look for an API
key and secret in the `CMM_API_ID` and `CMM_API_SECRET` environment variables
respectively.

### Rails

In Rails, the default client will also check `Rails.application.secrets` for a
`cmm_api_id` and `cmm_api_secret` before falling back to the environment
variables.

The gem also includes a Railtie to allow simple configuration in
`Rails.application.configure` blocks typically found in environment files like
`config/environments/development.rb` etc. Usage is similar to the standard
configuration.

```ruby
Rails.application.configure do
  config.cover_my_meds.default_host = 'https://master-api.integration.covermymeds.com'
end
```

This will configure the default client retrieved through
`CoverMyMeds.default_client`. If you want to pass your own API key and secret,
you can call `CoverMyMeds.configured_client(api_id, api_secret)` which will use
the same configuration, but the passed ID/secret.

### Without Rails

Before anything else, create a new client:

```ruby
client = CoverMyMeds::Client.new(your_api_id, your_api_secret) do |client|
  client.default_host = 'https://api.covermymeds.com'
end
```

## Drug Search

```ruby
drugs = client.drug_search 'Boniva'

drugs                   # => array of drugs
drug = drugs.first
drug.name               # => 'Boniva'
```

## Form Search

```ruby
forms = client.form_search('Blue Cross', drug.id, 'oh')

forms                   # => array of forms
form = forms.first
form.name               # => 'blue_cross_blue_shield_georgia_general'
```

## Get Request(s)

```ruby
# Get a single request
request = client.get_request('NT5HL9')
request.id  # => 'NT5HL9'

# Get many requests
requests = client.get_requests(['DS2FD3', 'FD6FD1'])
requests   # => array of requests
```

## Create Request

```ruby
new_request = client.request_data
request_data.patient.first_name = 'John'

request = client.create_request new_request
request.patient.first_name      # => 'Jonhn'
```


## Create access tokens

```ruby
token = client.create_access_token('DS3SE1')
token.id    # => 'nhe44fu4g22upqqgstea'
```

## Get Request Pages
```ruby
request_page = client.get_request_page('NT5HL9','nhe44fu4g22upqqgstea')
request_page.keys # => values corresponding to a request page

Or to save remote_user attributes to the request audit trail:
request_page = client.get_request_page('NT5HL9','nhe44fu4g22upqqgstea', { remote_user_key: 'remote_user_value' })
request_page.keys # => values corresponding to a request page
```
e.g ["data", "forms", "actions", "provided_coded_references", "validations"]

## Create API Consumer
```ruby
consumer = client.create_consumer(email: 'consumer@example.com')
consumer # => {"id"=>89517,
               "key"=>"api-key",
               "secret"=>"api-secret",
               "email"=>"consumer@example.com",
               "description"=>nil,
               "callback_url"=>nil,
               "callback_verb"=>"POST",
               "theming"=>nil,
               "created_at"=>"2015-12-22T14:33:25Z",
               "updated_at"=>"2015-12-22T14:33:25Z",
               "deleted_at"=>nil,
               "service_user_id"=>826414,
               "api_type"=>"NONE"}
```
Can optionally send in `description`, `callback_url`, `callback_verb`, `theming`.


## Create Root Consumers Request
```ruby
consumers_request = client.create_root_consumers_request 'api_key', 'request_id'
consumers_request # => #<Hashie::Mash 
  api_consumer_id=3903 
  consumer_key="api_key" 
  href="https://ehr1-api.testing.covermymeds.com/consumers/determinator/requests/request_id" 
  request_id="request_id" 
  request_url="https://ehr1-api.testing.covermymeds.com/requests/request_id?consumer_key=api_key"
>
