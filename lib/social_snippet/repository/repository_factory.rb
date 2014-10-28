module SocialSnippet

  module Repository

    module RepositoryFactory

      class << self

        def clone(repo_url)
          uri = URI.parse repo_url
          if is_git_repo(uri)
            path = GitRepository.download uri
            repo = create_git_repo(path)
            repo.set_url repo_url
            repo.load_snippet_json
            return repo
          else
            raise "unknown repository type"
          end
        end # clone

        def create_git_repo(repo_path)
          return GitRepository.new(repo_path)
        end

        def is_git_repo(uri)
          return true if uri.scheme === "git"
          return true if uri.host === "github.com"
          return false
        end

      end # class << self

    end # RepositoryFactory

  end # Repository

end # SocialSnippet
