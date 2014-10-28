require "spec_helper"

module SocialSnippet::CommandLine::Sspm

  describe SubCommands::InstallCommand, :install_current => true do

    before do
      stub_const "SocialSnippet::CommandLine::Sspm::SSPM_API_HOST", "api.server"
      stub_const "SocialSnippet::CommandLine::Sspm::SSPM_API_VERSION", "dummy"
      stub_const "SocialSnippet::CommandLine::Sspm::SSPM_API_PROTOCOL", "http"
    end # define constants

    context "create instance" do

      describe "$ sspm install my-repo" do

        let(:instance) { SubCommands::InstallCommand.new ["my-repo"] }
        before { instance.init }

        let(:result) do
          {
            "name" => "my-repo",
            "desc" => "This is my repository.",
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
            :body => result.to_json,
            :headers => {
              "Content-Type" => "application/json",
            },
          )
        end # GET /repositories/my-repo/dependencies

        before do
          expect(::SocialSnippet::Repository).to receive(:clone).once do
            repo = ::SocialSnippet::Repository::BaseRepository.new("/path/to/repo")
            expect(repo).to receive(:dependencies) do
              {}
            end
            repo
          end

          expect_any_instance_of(::SocialSnippet::Repository::RepositoryManager).to receive(:install_repository).once do
            true
          end
        end

        context "output" do

          it "my-repo" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "install" do
            expect { instance.run }.to output(/Install/).to_stdout
          end

          it "download" do
            expect { instance.run }.to output(/Download/).to_stdout
          end

          it "success" do
            expect { instance.run }.to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install my-repo

      describe "$ sspm install new-repo" do

        let(:instance) { SubCommands::InstallCommand.new ["new-repo"] }
        before { instance.init }

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
        end # GET /repositories/new-repo

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
            :body => new_repo_info.to_json,
            :headers => {
              "Content-Type" => "application/json",
            },
          )
        end # GET /repositories/my-repo

        before do
          expect(::SocialSnippet::Repository).to receive(:clone).twice do
            ::SocialSnippet::Repository::BaseRepository.new("/path/to/repo")
          end

          expect_any_instance_of(::SocialSnippet::Repository::RepositoryManager).to receive(:install_repository).twice do
            true
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

          it "download" do
            expect { instance.run }.to output(/Download/).to_stdout
          end

          it "success" do
            expect { instance.run }.to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install new-repo

      describe "$ sspm install --dry-run new-repo", :current => true do

        let(:instance) { SubCommands::InstallCommand.new ["--dry-run", "new-repo"] }
        before { instance.init }

        let(:result) do
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
            :body => result.to_json,
            :headers => {
              "Content-Type" => "application/json",
            },
          )
        end # GET /repositories/new-repo/dependencies

        before do
          expect(::SocialSnippet::Repository).not_to receive(:clone) do
            repo = ::SocialSnippet::Repository::BaseRepository.new("/path/to/repo")
            expect(repo).to receive(:dependencies) do
              {
                "my-repo" => "1.0.0",
              }
            end
          end

          expect_any_instance_of(::SocialSnippet::Repository::RepositoryManager).not_to receive(:install_repository) do
            true
          end
        end

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

          it "download" do
            expect { instance.run }.not_to output(/Download/).to_stdout
          end

          it "success" do
            expect { instance.run }.not_to output(/Success/).to_stdout
          end

        end # output

      end # $ sspm install new-repo

    end # create instance

  end # SubCommands::InstallCommand

end # SocialSnippet::CommandLine::Sspm
