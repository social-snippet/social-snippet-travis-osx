module SocialSnippet

  module Cli

    module Sspm

      module Subcommands

        module Search

          @options = {}

          def self.parse_options
            OptionParser.new do |opt|
              opt.parse! ARGV
            end
          end

          def self.set_default_options
          end

          def self.run
            parse_options
            set_default_options

            query = ARGV.shift

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
