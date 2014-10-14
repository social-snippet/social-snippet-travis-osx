module SocialSnippet

  module Cli

    module Sspm

      module Subcommands

        module Hello

          @options = {}

          def self.parse_options
            OptionParser.new do |opt|
              opt.on("-n", "--name=NAME", "name") do |value|
                @options[:name] = value
              end
              opt.parse! ARGV
            end
          end

          def self.set_default_options
          end

          def self.run
            parse_options
            set_default_options

            puts "Hello #{@options[:name]}"
          end

        end

      end

    end

  end

end
