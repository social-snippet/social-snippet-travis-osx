module SocialSnippet

  module CommandLine

    module Sspm

      class MainCommand < Command

        SUB_COMMANDS = SubCommands.all.freeze

        def define_options
        end

        def set_default_options
        end

        def run
          if has_subcommand?
            command_name = @args.shift
            call_subcommand command_name
          else
            Sspm.show_usage
          end
        end

        private

        def call_subcommand(name)
          # hello -> HelloCommand
          sub_command = "#{name.capitalize}Command".to_sym

          if SUB_COMMANDS.include?(sub_command)
            Sspm::SubCommands.const_get(sub_command).new(args).run
          else
            Sspm::SubCommands.show_usage
          end
        end

      end

    end

  end

end
