module CoverMyMeds
  module RequestPages
    include HostAndPath

    CURRENT_VERSION = 1

    def get_request_page request_id, token_id, remote_user = {}, version = CURRENT_VERSION
      params = { token_id: token_id, v: version , remote_user: remote_user }
      request_page = request_pages_request(
        GET, params: params, path: request_id, auth: :bearer
      )
      QuietMash.new(request_page["request_page"])
    end
  end
end
