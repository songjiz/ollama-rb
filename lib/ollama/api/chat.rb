# frozen_string_literal: true

module Ollama
  module API
    class Chat
      def initialize(client:)
        @client = client
      end

      def create(model:, messages:, **options, &block)
        json = {
          model: model,
          messages: messages
        }.merge(options).compact.transform_keys(&:to_sym)

        json[:stream] = block_given?

        @client.post "/api/chat", json: json, &block
      end
    end
  end
end
