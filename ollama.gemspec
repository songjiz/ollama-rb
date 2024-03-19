# frozen_string_literal: true

require_relative "lib/ollama/version"

Gem::Specification.new do |spec|
  spec.name = "ollama-rb"
  spec.version = Ollama::VERSION
  spec.authors = [ "songji.zeng" ]
  spec.email = [ "songji.zeng@outlook.com" ]

  spec.summary = "Ollama Ruby library"
  spec.description = "The Ollama Ruby library provides the easiest way to integrate your Ruby project with Ollama."
  spec.homepage = "https://github.com/songjiz/ollama-rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/songjiz/ollama-rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
