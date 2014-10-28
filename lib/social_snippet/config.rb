module SocialSnippet
  class Config
    attr_reader :home
    attr_reader :sspm_host
    attr_reader :sspm_version
    attr_reader :sspm_protocol

    # Constructor
    def initialize(value = {})
      load_from_arg value
      load_from_environment_variables
      load_default_value
    end

    private

    def load_from_arg(value)
      @home           = value[:home]          unless value[:home].nil?
      @sspm_host      = value[:sspm_host]     unless value[:sspm_host].nil?
      @sspm_version   = value[:sspm_version]  unless value[:sspm_version].nil?
      @sspm_protocol  = value[:sspm_protocol] unless value[:sspm_protocol].nil?
    end

    # Load environmental variables
    def load_from_environment_variables
      # TODO: use keys
      # TODO: :@sspm_host => SOCIAL_SNIPPET_SSPM_HOST
      @home = ENV['SOCIAL_SNIPPET_HOME']
    end

    # Load default values
    def load_default_value
      @home ||= "#{ENV['HOME']}/.social-snippet"

      @sspm_host      ||= "sspm-test.herokuapp.com" # TODO: change host
      @sspm_version   ||= "v0"
      @sspm_protocol  ||= "https"
    end
  end
end

