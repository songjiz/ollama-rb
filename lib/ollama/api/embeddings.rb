# frozen_string_literal: true

module Ollama
  module API
    class Embeddings
      def initialize(client:)
        @client = client
      end

      def create(model:, prompt:, **options)
        @client.post "/api/embeddings", json: { model: model, prompt: prompt }.merge(options).compact
      end
    end
  end
end
