module SocialSnippet

  module Registry

    require "rest_client"

    class RegistryClient

      attr_reader :repositories

      def initialize(config)
        @repositories = RegistryResources::Repositories.new(config)
      end

    end

  end

end
