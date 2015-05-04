# CoverMyMeds API

CoverMyApi is a gem that provides a Ruby client for api.covermymeds.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'covermymeds_api'
```

And then execute:

```
bundle
```

*For general API documentation see: https://api.covermymeds.com*

## Contributing

Fork the repo, make changes, and submit a pull request.

## Usage

You can use the CoverMyApi client to retrieve drugs, forms, pa requests, access tokens and create requests.

```ruby
require 'covermymeds_api'  # not needed in a rails app
```

## Getting Started

Before anything else, create a new client:

```ruby
client = CoverMyMeds::Client.new(your_api_id, your_api_secret) do |client|
client.contacts_path = '/'
client.contacts_host = 'http://contacts-api.dev'
end
```

## Drug Search

```ruby
drugs = client.drug_search 'Boniva'

drugs                   # => array of drugs
drug = drug.first
drug.name               # => 'Boniva'
```

## Form Search

```ruby
forms = client.form_search('Blue Cross', drug.id, 'oh')

forms                   # => array of forms
form = form.first
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
