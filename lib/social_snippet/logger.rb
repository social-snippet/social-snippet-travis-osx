require "logger"

module SocialSnippet

  class Logger < ::Logger

    def say(s)
      puts s if info?
    end

  end

end
