# frozen_string_literal: true
require 'colorize'

namespace :version do
  desc 'Bump the gem version and update the CHANGELOG.md, default type: patch'
  task :bump, %i[type] do |_t, args|
    args.with_defaults(type: 'patch')
    type = args[:type]

    valid_types = %w[patch minor major]
    abort "Invalid version type. Allowed types: #{valid_types.join(', ')}".red unless valid_types.include?(type)

    # Check for uncommitted changes
    tracked_files_clean = `git diff --exit-code`.empty? && `git diff --cached --exit-code`.empty?
    abort 'There are uncommitted changes. Please commit or stash.'.red unless tracked_files_clean

    # check_dependencies
    abort('You must have the "bump" gem installed to use these tasks.') unless system('which bump > /dev/null 2>&1')
    abort('You must have "cocogitto" installed to use these tasks.') unless system('which cog > /dev/null 2>&1')

    # Bump the tag, update the changelog and commit
    system "cog bump --#{type}"
    puts 'Updated CHANGELOG.md'.green
  end

  desc 'Bump the patch version and update the CHNAGELOG.md'
  task :patch do
    Rake::Task['version:bump'].invoke('patch')
  end

  desc 'Bump the minor version and update the CHNAGELOG.md'
  task :minor do
    Rake::Task['version:bump'].invoke('minor')
  end

  desc 'Bump the major version and update the CHNAGELOG.md'
  task :major do
    Rake::Task['version:bump'].invoke('major')
  end
end
