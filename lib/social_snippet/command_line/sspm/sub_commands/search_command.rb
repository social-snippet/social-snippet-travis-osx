module SocialSnippet

  module CommandLine

    module Sspm

      module SubCommands

        class SearchCommand < Command

          attr_reader :query

          def initialize(new_args)
            super
            @query = args.find {|arg| is_not_line_option? arg }
          end

          def define_options
          end

          def set_default_options
          end

          def run
            # TODO: change host
            client = ::SocialSnippet::RegistryClient.new("sspm-test.herokuapp.com", "v0", "https")
            client.get_repositories(query).each do |repo|
              puts "%s: %s" % [repo["name"], repo["desc"]]
            end
          end

        end

      end

    end

  end

end
