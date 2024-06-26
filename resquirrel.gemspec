# frozen_string_literal: true

require_relative "lib/resquirrel/version"

Gem::Specification.new do |spec|
  spec.name = "resquirrel"
  spec.version = Resquirrel::VERSION
  spec.authors = ["yuki-snow1823"]
  spec.email = ["y.horikoshi.pg@gmail.com"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.summary = "The library to support the creation of release notes"
  spec.description = "RubyGems that automatically create release notes for Notion DB using Open AI API when PR merge."
  spec.homepage = "https://github.com/yuki-snow1823/resquirrel"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yuki-snow1823/resquirrel"
  spec.metadata["changelog_uri"] = "https://github.com/yuki-snow1823/resquirrel/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[spec/ .git .github Gemfile])
    end
  end
  spec.require_paths = ["lib"]
end
