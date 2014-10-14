require_relative "sspm/subcommands"

module SocialSnippet

  module Cli

    module Sspm

      SUB_COMMANDS = Subcommands.constants.freeze

      class << self

        def has_subcommand?
          return ARGV.length > 0
        end

        def call_subcommand(name)
          sub_command = name.capitalize.to_sym
          flag_exists = SUB_COMMANDS.include?(sub_command)
          if flag_exists
            Sspm::Subcommands.const_get(sub_command).run
          else
            Sspm::Subcommands.help
          end
        end

      end

    end

  end

end
