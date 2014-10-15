module SocialSnippet

  module CommandLine

    module Sspm

      module SubCommands

        class SearchCommand

          def parse_options
            OptionParser.new do |opt|
              opt.parse! args
            end
          end

          def set_default_options
          end

          def run
            query = @args.shift

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
