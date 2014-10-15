module SocialSnippet

  module CommandLine

    module Sspm

      module SubCommands

        class SearchCommand < Command

          attr_reader :query
          attr_reader :client

          def initialize(new_args)
            super

            @query = args.find {|arg| is_not_line_option? arg }

            @client = ::SocialSnippet::RegistryClient.new(
              SSPM_API_HOST,
              SSPM_API_VERSION,
              SSPM_API_PROTOCOL,
            )
          end

          def define_options
          end

          def set_default_options
          end

          def run
            # TODO: change host
            client.get_repositories(query).each do |repo|
              puts "%s: %s" % [repo["name"], repo["desc"]]
            end
          end

        end

      end

    end

  end

end
