module SocialSnippet

  module CommandLine

    class Command

      attr_reader :args
      attr_reader :options
      attr_reader :opt_parser

      def initialize(new_args)
        @args = new_args.clone
        @options = {}
        @opt_parser = OptionParser.new

        init
      end

      def define_options
        raise "not implement"
      end

      def set_default_options
        raise "not implement"
      end

      def run
        raise "not implement"
      end

      private

      def my_args
        last_ind = args.index do |arg|
          false === arg.start_with?("-")
        end
        if last_ind.nil?
          args
        else
          args[0 .. last_ind]
        end
      end

      def has_subcommand?
        return false if args.empty?
        return false if args[0].start_with?("-")
        return true
      end

      def init
        define_options
        opt_parser.parse! my_args
        set_default_options
      end

    end

  end

end
