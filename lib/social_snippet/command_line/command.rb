#
# Usage:
#
# class SomeCommand < Command; end
# cli = SomeCommand.new [arg1, arg2, ...]
# cli.init
# cli.run
#

module SocialSnippet

  module CommandLine

    require "optparse"

    class Command

      attr_reader :args
      attr_reader :tokens
      attr_reader :options
      attr_reader :opt_parser
      attr_reader :input

      def initialize(new_args, input = "")
        @args = new_args.clone
        @options = {}
        @tokens = [] # init after parse options
        @opt_parser = OptionParser.new
        @input = input
      end

      def define_options
        raise "not implement"
      end

      def set_default_options
        raise "not implement"
      end

      def init
        define_options
        parse_line_options
        @tokens = args
        set_default_options
      end

      def run
        raise "not implement"
      end

      private

      def parse_line_options
        last_ind = last_line_option_index
        if last_ind.nil?
          parsed = args.clone
        else
          parsed = args[0 .. last_ind]
        end
        @args = opt_parser.parse(parsed).concat(args[last_ind + 1..-1])
      end

      def last_line_option_index
        args.index do |arg|
          is_not_line_option?(arg)
        end
      end

      # hello -> HelloCommand
      def to_command_class_sym(s)
        "#{s.capitalize}Command".to_sym
      end

      def is_line_option?(s)
        return true if /^-[a-zA-Z0-9]$/ === s
        return true if /^--/ === s
        return false
      end

      def is_not_line_option?(s)
        is_line_option?(s) === false
      end

      def has_subcommand?
        return false if args.empty?
        return false if args[0].start_with?("-")
        return true
      end

      # [--opt1, --opt2, token1, token2] => token1
      def next_token
        @tokens.shift
      end

      def has_next_token?
        not @tokens.empty?
      end

    end

  end

end
