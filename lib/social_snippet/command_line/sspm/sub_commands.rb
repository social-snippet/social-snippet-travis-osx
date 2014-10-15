require_relative "sub_commands/hello_command"
require_relative "sub_commands/search_command"

module SocialSnippet

  module CommandLine

    module Sspm

      module SubCommands

        def self.all
          commands = SubCommands.constants.select do |name|
            /.+Command$/ === name
          end
          commands
        end

      end

    end

  end

end
