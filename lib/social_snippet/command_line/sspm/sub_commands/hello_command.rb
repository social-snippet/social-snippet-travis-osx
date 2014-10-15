module SocialSnippet

  module CommandLine

    module Sspm

      module SubCommands

        class HelloCommand < Command

          def define_options
            opt_parser.on("-n", "--name=NAME", "name") do |value|
              @options[:name] = value
            end
          end

          def set_default_options
          end

          def run
            puts "Hello #{options[:name]}"
          end

        end

      end

    end

  end

end
