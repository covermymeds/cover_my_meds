module CoverMyMeds
  module Tokens
    include HostAndPath

    CURRENT_VERSION = 1

    def create_access_token request_id, version=CURRENT_VERSION
      params = {'request_ids[]' => request_id, v: version}
      data = tokens_request POST, params: params
      Hashie::Mash.new data['tokens'].first
    end

    def revoke_access_token? token_id, version=CURRENT_VERSION
       params = { v: version }
       tokens_request DELETE, path: token_id, params: params
    end

    # Override the meta-programming in this oddball case
    def tokens_path
      @tokens_path || "/requests/tokens/"
    end

  end
end
