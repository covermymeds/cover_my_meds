module CoverMyMeds
  module Consumers
    include HostAndPath

    CURRENT_VERSION = 1

    def create_consumer(consumer_params, version = CURRENT_VERSION)
      data = consumers_request POST, params: consumer_params.merge(v: version)
      Hashie::Mash.new(data['root_consumer'])
    end
  end
end
