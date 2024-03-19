# frozen_string_literal: true

require_relative "ollama/version"
require_relative "ollama/client"

module Ollama
  USER_AGENT = "ollama-rb/#{VERSION}"
  class Error < StandardError; end
end
