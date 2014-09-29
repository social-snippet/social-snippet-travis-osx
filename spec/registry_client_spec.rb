require "spec_helper"

module SocialSnippet

  describe RegistryClient do

    # enable WebMock
    before { WebMock.disable_net_connect! }

    # enable FakeFS
    before { FakeFS.activate! }
    after { FakeFS.deactivate!; FakeFS::FileSystem.clear }

    before do
      WebMock
        .stub_request(
          :get,
          "http://api.server/api/v0/repositories",
        )
        .to_return(
          :status => 200,
          :body => [
            {
              "name" => "my-repo",
              "desc" => "This is my repository.",
            },
            {
              "name" => "new-repo",
              "desc" => "This is my repository.",
            },
          ].to_json,
          :headers => {
            "Content-Type" => "application/json",
          },
        )
    end

    context "create instance" do

      let(:instance) { RegistryClient.new("api.server", "v0") }

      context "get_repositories" do

        let(:result) { instance.get_repositories }

        context "check result" do
          let(:result_names) { result.map {|repo| repo["name"] } }
          it { expect(result.length).to eq 2 }
          it { expect(result_names).to include "my-repo" }
          it { expect(result_names).to include "new-repo" }
        end

      end # get_repositories

    end # create instance

  end # RegistryClient

end # SocialSnippet
