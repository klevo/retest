module Retest
  class Program
    attr_accessor :runner, :repository, :command
    def initialize(runner: nil, repository: nil, command: nil)
      @runner = runner
      @repository = repository
      @command = command
    end

    def start
      puts "Launching Retest..."
      build.start
      puts "Ready to refactor! You can make file changes now"
    end

    def diff(branch)
      raise "Git not installed" unless VersionControl::Git.installed?
      test_files = repository.find_tests VersionControl::Git.diff_files(branch)

      puts "Tests found:"
      test_files.each { |test_file| puts "  - #{test_file}" }

      puts "Running tests..."
      command.run_all *test_files, runner: runner
    end

    private

    def build
      Listen.to('.', only: /\.rb$/, relative: true) do |modified, added, removed|
        begin
          repository.add(added)
          repository.remove(removed)
          runner.remove(removed)
          system('clear 2>/dev/null') || system('cls 2>/dev/null')

          runner.run test_file_to_run(modified + added)
        rescue => e
          puts "Something went wrong: #{e.message}"
        end
      end
    end

    def test_file_to_run(changed_files)
      repository.find_test changed_files.first if runner.matching?
    end
  end
end