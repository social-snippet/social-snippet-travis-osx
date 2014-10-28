module SocialSnippet

  module CommandLine
    
    module Sspm

      module SubCommands

        class InstallCommand < Command

          attr_reader :social_snippet

          def initialize(new_args)
            super

            @social_snippet = ::SocialSnippet::SocialSnippet.new
          end

          def define_options
            # Does not install
            opt_parser.on "-d", "--dry-run" do
              options[:dry_run] = true
            end
          end

          def set_default_options
            options[:dry_run] if options[:dry_run].nil?
          end

          def run
            while has_next_token?
              repo_name = next_token
              social_snippet.install_repository repo_name, options
            end
          end

        end

      end

    end

  end

end
