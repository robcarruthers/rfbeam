# frozen_string_literal: true

require_relative 'lib/rfbeam/version'

Gem::Specification.new do |spec|
  spec.name = 'rfbeam'
  spec.version = RfBeam::VERSION
  spec.authors = ['Rob Carruthers']
  spec.email = ['robc@hey.com']

  spec.summary = 'Ruby API and CLI for RFBeam doplar radar modules'
  spec.description = 'Currently only tested with K-LD7 on MacOS & Raspian (bullseye)'
  spec.homepage = 'https://gitlab.com/robcarruthers/rfbeam'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.2'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://gitlab.com/robcarruthers/rfbeam'
  spec.metadata['changelog_uri'] = 'https://gitlab.com/robcarruthers/rfbeam/-/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0")
        .reject do |f|
          (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
        end
    end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'activesupport', '~> 6.1.0'
  spec.add_dependency 'rubyserial', '~> 0.6.0'
  spec.add_dependency 'thor', '~> 1.2.1'
  spec.add_dependency 'tty-logger', '~> 0.6.0'
  spec.add_dependency 'tty-screen', '~> 0.8.1'
  spec.add_dependency 'tty-spinner', '~> 0.9.3'
  spec.add_dependency 'tty-table', '~> 0.12.0'
  spec.add_dependency 'unicode_plot', '~> 0.0.5'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
