require_relative "social_snippet/version"
require_relative "social_snippet/tag"
require_relative "social_snippet/tag_parser"
require_relative "social_snippet/config"
require_relative "social_snippet/repository"
require_relative "social_snippet/context"
require_relative "social_snippet/snippet"
require_relative "social_snippet/inserter"
require_relative "social_snippet/snippet_finder"
require_relative "social_snippet/registry"
require_relative "social_snippet/command_line"
require_relative "social_snippet/logger"

require "tsort"

# Extend Hash tsortable
class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

module SocialSnippet

  class SocialSnippet
    attr_reader :repo_manager
    attr_reader :config
    attr_reader :client
    attr_reader :logger

    # Constructor
    def initialize
      @config = ::SocialSnippet::Config.new.freeze
      @logger = ::SocialSnippet::Logger.new STDOUT
      logger.level = ::SocialSnippet::Logger::Severity::INFO
      init_repo_manager
      init_registry_client
    end

    # Initialize for repository
    def init_repo_manager
      @repo_manager = ::SocialSnippet::Repository::RepositoryManager.new(config, logger)
    end

    def init_registry_client
      @client = ::SocialSnippet::Registry::RegistryClient.new(config)
    end

    # Insert snippets to given text
    #
    # @param src [String] The text of source code
    def insert_snippet(src)
      searcher = SnippetFinder::SnippetFinderWithInsert.new(repo_manager)
      return searcher.insert(src)
    end

    # Install repository
    #
    # @param repo [::SocialSnippet::Repository::Drivers::BaseRepository]
    def install_repository(repo_name, options = {})
      repo_manager.install_repository repo_name, options
    end

  end
end

