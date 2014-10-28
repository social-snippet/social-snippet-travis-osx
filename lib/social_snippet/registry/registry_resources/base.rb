module SocialSnippet

  module Registry

    module RegistryResources

      class Base

        attr_reader :rest_client
        attr_reader :protocol
        attr_reader :host
        attr_reader :api_version

        DEFAULT_HEADERS = {
          :accept => :json,
        }

        def initialize(config)
          @host         = config.sspm_host
          @api_version  = config.sspm_version
          @protocol     = config.sspm_protocol

          @rest_client = RestClient::Resource.new("#{protocol}://#{host}/api/#{api_version}")
        end

        def get(req_path, headers = {})
          headers.merge! DEFAULT_HEADERS
          JSON.parse rest_client[req_path].get(headers)
        end

      end # Base

    end # RegistryResources

  end # Registry

end
