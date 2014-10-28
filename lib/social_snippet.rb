require_relative "social_snippet/version"
require_relative "social_snippet/tag"
require_relative "social_snippet/tag_parser"
require_relative "social_snippet/config"
require_relative "social_snippet/repository"
require_relative "social_snippet/repository_manager"
require_relative "social_snippet/repository_factory"
require_relative "social_snippet/context"
require_relative "social_snippet/snippet"
require_relative "social_snippet/inserter"
require_relative "social_snippet/snippet_finder"
require_relative "social_snippet/registry_client"
require_relative "social_snippet/command_line"
require_relative "social_snippet/logger"

require "rugged"
require "version_sorter"
require "tsort"
require "rest_client"
require "optparse"
require "json"
require "pathname"
require "logger"

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
      @config = Config.new.freeze
      @logger = Logger.new STDOUT
      init_repo_manager
      init_registry_client
    end

    # Initialize for repository
    def init_repo_manager
      @repo_manager = RepositoryManager.new(config, logger)
    end

    def init_registry_client
      @client = RegistryClient.new(config)
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
    # @param repo [SocialSnippet::BaseRepository]
    def install_repository(repo)
      repo_manager.install_repository repo
    end

  end
end

