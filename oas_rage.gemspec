# frozen_string_literal: true

require_relative 'lib/oas_rage/version'

Gem::Specification.new do |spec|
  spec.name = 'oas_rage'
  spec.version = OasRage::VERSION
  spec.authors = ['a-chacon']
  spec.email = ['andres.ch@protonmail.com']

  spec.summary = 'OasRage is a tool for generating automatic interactive documentation for your APIs.'
  spec.description = <<~DESC
    OasRage is a ruby gem for generating automatic interactive documentation for your Rage APIs.
    It generates an OAS 3.1 document and displays it using RapiDoc.
  DESC
  spec.homepage = 'https://github.com/a-chacon/oas_rage'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/a-chacon/oas_rage'
  spec.metadata['changelog_uri'] = 'https://github.com/achacon/oas_rage/blob/main/CHANGELOG.md'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'erb', '~> 5.0', '>= 5.0.1'
  spec.add_dependency 'oas_core', '~> 0.5.2'
  spec.add_dependency 'rack', '~> 2.0 '
end
