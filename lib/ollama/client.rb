# frozen_string_literal: true

require "forwardable"
require_relative "connection"
require_relative "api/blobs"
require_relative "api/chat"
require_relative "api/completion"
require_relative "api/embeddings"
require_relative "api/models"

module Ollama
  class Client
    extend Forwardable

    def_delegators :@connection, :post, :get, :delete, :head

    def initialize(base_url: "http://localhost:11434", logger: nil, **options)
      @connection = Connection.new(base_url, logger: logger, **options)
    end

    def chat
      API::Chat.new client: self
    end

    def completion
      API::Completion.new client: self
    end

    def models
      API::Models.new client: self
    end

    def blobs
      API::Blobs.new client: self
    end

    def embeddings
      API::Embeddings.new client: self
    end
  end
end
