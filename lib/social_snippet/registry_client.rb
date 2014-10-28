module SocialSnippet

  class RegistryClient

    attr_reader :config
    attr_reader :client
    attr_reader :protocol
    attr_reader :host
    attr_reader :api_version

    DEFAULT_HEADERS = {
      :accept => :json,
    }

    def initialize(new_config)
      @config = new_config

      @host         = config.sspm_host
      @api_version  = config.sspm_version
      @protocol     = config.sspm_protocol

      @client = RestClient::Resource.new("#{protocol}://#{host}/api/#{api_version}")
    end

    def get(req_path, headers = {})
      headers.merge! DEFAULT_HEADERS
      JSON.parse client[req_path].get(headers)
    end

    def repositories(query = nil)
      url = "repositories"
      if query.nil?
        get "repositories"
      else
        get "repositories?q=#{query}"
      end
    end

    def repository(repo_name)
      get "repositories/#{repo_name}"
    end

    def dependencies(repo_name)
      get "repositories/#{repo_name}/dependencies"
    end

  end

end
