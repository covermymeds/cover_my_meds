module CoverMyMeds
  module Consumers
    include HostAndPath

    CURRENT_VERSION = 1

    def create_consumer consumer_params, version = CURRENT_VERSION
      data = consumers_request POST, params: { v: version } do
        { 'consumer' => consumer_params }
      end
      data['root_consumer']
    end
  end
end
