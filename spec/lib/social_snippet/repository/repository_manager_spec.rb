require "spec_helper"

module SocialSnippet::Repository

  describe RepositoryManager, :repository_manager_current => true do

    # Enable FakeFS
    before { FakeFS.activate! }
    after { FakeFS.deactivate!; FakeFS::FileSystem.clear }

    let(:logger) do
      logger = ::SocialSnippet::Logger.new(STDOUT)
      logger.level = ::SocialSnippet::Logger::Severity::UNKNOWN
      logger
    end

    let(:config) do
      ::SocialSnippet::Config.new
    end

    let(:instance) { RepositoryManager.new(config, logger) }
    let(:repo_manager) { RepositoryManager.new(config, logger) }
    let(:commit_id) { "dummycommitid" }
    let(:short_commit_id) { commit_id[0..7] }

    describe "#resolve_snippet_path" do

      context "without repo" do

        context "cur = path/to/file.cpp" do

          let(:context) { ::SocialSnippet::Context.new("path/to/file.cpp") }

          context "@snip<./file2.cpp>" do

            let(:tag) { ::SocialSnippet::Tag.new("// @snip<./file2.cpp>") }

            context "result" do
              subject { instance.resolve_snippet_path(context, tag) }
              it { should eq "path/to/file2.cpp" }
            end

          end # snip<./file2.cpp>

          context "@snip <./subdir/file3.cpp>" do

            let(:tag) { ::SocialSnippet::Tag.new("// @snip <./subdir/file3.cpp>") }

            context "result" do
              subject { instance.resolve_snippet_path(context, tag) }
              it { should eq "path/to/subdir/file3.cpp" }
            end

          end # snip <./subdir/file3.cpp>

        end # cur = path/to/file.cpp

      end # without repo

      context "with repo" do

        before { ENV["SOCIAL_SNIPPET_HOME"] = "/path/to" }
        after { ENV.delete "SOCIAL_SNIPPET_HOME" }

        let(:repo_path) { "#{ENV["SOCIAL_SNIPPET_HOME"]}/repo" }

        before do
          FileUtils.mkdir_p "#{repo_path}/repo_a"
          FileUtils.mkdir_p "#{repo_path}/repo_a/.git"
          FileUtils.touch   "#{repo_path}/repo_a/snippet.json"

          File.write "#{repo_path}/repo_a/snippet.json", [
            '{',
            '  "name": "repo_a",',
            '  "desc": "this is repo_a",',
            '  "language": "C++",',
            '  "main": "src"',
            '}',
          ].join("\n")

          allow(instance).to receive(:find_repository).with("repo_a") do |path|
            repo = ::SocialSnippet::Repository::Drivers::BaseRepository.new("#{repo_path}/repo_a")
            expect(repo).to receive(:get_commit_id).and_return commit_id
            repo.load_snippet_json
            repo.create_cache instance.repo_cache_path
            repo
          end
        end

        context "cur = path/to/file.cpp" do

          let(:context) { ::SocialSnippet::Context.new("path/to/file.cpp") }

          context "@snip<repo_a:path/to/file2.cpp>" do

            let(:tag) { ::SocialSnippet::Tag.new("// @snip<repo_a:path/to/file2.cpp>") }

            context "result" do
              subject { instance.resolve_snippet_path(context, tag) }
              it { should eq "/path/to/repo_cache/repo_a/#{commit_id[0..7]}/src/path/to/file2.cpp" }
            end

          end # snip<./file2.cpp>

        end # cur = path/to/file.cpp

      end # with repo

    end # resolve_snippet_path

    describe "#find_repository" do

      let(:repo_path) { "#{ENV["HOME"]}/.social-snippet/repo" }

      context "create repo_a as a git repo" do

        before do
          FileUtils.mkdir_p "#{repo_path}/repo_a"
          FileUtils.mkdir_p "#{repo_path}/repo_a/.git"
          FileUtils.touch   "#{repo_path}/repo_a/snippet.json"

          File.write "#{repo_path}/repo_a/snippet.json", [
            '{',
            '  "name": "repo_a",',
            '  "desc": "this is repo_a",',
            '  "language": "C++"',
            '}',
          ].join("\n")
        end

        before do
          expect(::SocialSnippet::Repository::Drivers::GitRepository).to receive(:new) do |path|
            ::SocialSnippet::Repository::Drivers::BaseRepository.new(path)
          end
          expect_any_instance_of(::SocialSnippet::Repository::Drivers::BaseRepository).to receive(:get_refs).and_return []
          expect_any_instance_of(::SocialSnippet::Repository::Drivers::BaseRepository).to receive(:get_commit_id).and_return commit_id
        end

        context "find repo_a" do
          let(:repo) { instance.find_repository("repo_a") }
          it { expect(repo.name).to eq "repo_a" }
          it { expect(repo.desc).to eq "this is repo_a" }
        end # find repo_a

      end # create three repos

    end # find_repository

    describe "#install_repository" do

      context "install my-repo" do

        it do
          instance.install_repository "my-repo"
        end

      end

    end

  end # RepositoryManager

end # SocialSnippet::Repository
