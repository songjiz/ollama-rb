# frozen_string_literal: true

module Ollama
  module API
    class Completion
      def initialize(client:)
        @client = client
      end

      def create(model:, prompt:, images: [], **options, &block)
        json = {
          model: model,
          prompt: prompt,
          images: images
        }.merge(options).compact.transform_keys(&:to_sym)

        json[:stream] = block_given?

        @client.post "/api/generate", json: json, &block
      end

      alias generate create
    end
  end
end
