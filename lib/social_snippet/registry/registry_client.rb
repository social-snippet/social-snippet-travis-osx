module SocialSnippet

  module Registry

    class RegistryClient

      attr_reader :repositories

      def initialize(config)
        @repositories = RegistryResources::Repositories.new(config)
      end

    end

  end

end
