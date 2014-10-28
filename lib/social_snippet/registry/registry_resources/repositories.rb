module SocialSnippet

  module Registry

    module RegistryResources

      class Repositories < Base

        def all
          get "repositories"
        end

        def search(query)
          get "repositories?q=#{query}"
        end

        def find(repo_name)
          get "repositories/#{repo_name}"
        end

        def dependencies(repo_name)
          get "repositories/#{repo_name}/dependencies"
        end

      end # Repositories

    end # RegistryResources

  end # Registry

end # SocialSnippet
