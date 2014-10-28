require "spec_helper"

module SocialSnippet::CommandLine::Sspm

  describe SubCommands::InstallCommand do

    before do
      allow_any_instance_of(::SocialSnippet::SocialSnippet).to receive(:logger) do
        logger = ::SocialSnippet::Logger.new STDOUT
        logger.level = ::SocialSnippet::Logger::Severity::INFO
        logger
      end
    end # set logger.level

    before do
      allow_any_instance_of(::SocialSnippet::Registry::RegistryResources::Base).to receive(:rest_client) do
        RestClient::Resource.new "http://api.server/api/dummy"
      end
    end # use dummy api server

    let(:my_repo_info) do
      {
        "name" => "my-repo",
        "desc" => "This is new repository.",
        "url" => "git://github.com/user/my-repo",
        "dependencies" => {
        },
      }
    end # result

    before do
      WebMock
        .stub_request(
          :get,
          "http://api.server/api/dummy/repositories/my-repo",
        )
        .to_return(
          :status => 200,
          :body => my_repo_info.to_json,
          :headers => {
            "Content-Type" => "application/json",
          },
        )
    end # GET /repositories/my-repo/dependencies

    let(:new_repo_info) do
      {
        "name" => "new-repo",
        "desc" => "This is new repository.",
        "url" => "git://github.com/user/new-repo",
        "dependencies" => {
          "my-repo" => "1.0.0",
        },
      }
    end # result

    before do
      WebMock
        .stub_request(
          :get,
          "http://api.server/api/dummy/repositories/new-repo",
        )
        .to_return(
          :status => 200,
          :body => new_repo_info.to_json,
          :headers => {
            "Content-Type" => "application/json",
          },
        )
    end # GET /repositories/new-repo/dependencies

    before do
      expect(::SocialSnippet::Repository::RepositoryFactory).to receive(:clone) do
        class FakeRepo
          attr_reader :path
        end

        repo = FakeRepo.new
        allow(repo).to receive(:path).and_return "/path/to/repo"
        repo
      end
    end

    before do
      allow(::FileUtils).to receive(:cp_r) do
      end
    end

    context "create instance" do

      describe "$ sspm install my-repo" do

        let(:instance) { SubCommands::InstallCommand.new ["my-repo"] }
        before { instance.init }

        before do
          allow(::SocialSnippet::Repository::RepositoryFactory).to receive(:clone) do
            repo = ::SocialSnippet::Repository::Drivers::BaseRepository.new("/path/to/repo")
            expect(repo).to receive(:dependencies) do
              {}
            end
            repo
          end
        end

        context "output" do

          it "my-repo" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "install" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "clone" do
            expect { instance.run }.to output(/Clone/).to_stdout
          end

          it "success" do
            expect { instance.run }.to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install my-repo

      describe "$ sspm install new-repo" do

        let(:instance) { SubCommands::InstallCommand.new ["new-repo"] }
        before { instance.init }

        before do
          allow(::SocialSnippet::Repository::RepositoryFactory).to receive(:clone) do
            ::SocialSnippet::Repository::Drivers::BaseRepository.new("/path/to/repo")
          end
        end

        context "output" do

          it "my-repo" do
            expect { instance.run }.to output(/my-repo/).to_stdout
          end

          it "new-repo" do
            expect { instance.run }.to output(/new-repo/).to_stdout
          end

          it "my-repo -> new-repo" do
            expect { instance.run }.to output(/my-repo.*new-repo/m).to_stdout
          end

          it "install" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "clone" do
            expect { instance.run }.to output(/Clone/).to_stdout
          end

          it "success" do
            expect { instance.run }.to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install new-repo

      describe "$ sspm install --dry-run new-repo" do

        let(:instance) { SubCommands::InstallCommand.new ["--dry-run", "new-repo"] }
        before { instance.init }

        context "output" do

          it "my-repo" do
            expect { instance.run }.to output(/my-repo/).to_stdout
          end

          it "new-repo" do
            expect { instance.run }.to output(/new-repo/).to_stdout
          end

          it "new-repo -> my-repo" do
            expect { instance.run }.to output(/new-repo.*my-repo/m).to_stdout
          end

          it "install" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "clone" do
            expect { instance.run }.to output(/Clone/).to_stdout
          end

          it "success" do
            expect { instance.run }.to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install new-repo

    end # create instance

  end # SubCommands::InstallCommand

end # SocialSnippet::CommandLine::Sspm
