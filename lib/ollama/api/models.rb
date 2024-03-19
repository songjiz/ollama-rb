# frozen_string_literal: true

module Ollama
  module API
    class Models
      def initialize(client:)
        @client = client
      end

      def list
        @client.get "/api/tags"
      end

      def create(name:, modelfile: nil, path: nil, &block)
        @client.post "/api/create", json: { name: name, modelfile: modelfile, path: path, stream: block_given? }.compact, &block
      end

      def show(name)
        @client.post "/api/show", json: { name: name }
      end

      def copy(source:, destination: nil)
        @client.post "/api/copy", json: { source: source, destination: destination || "#{source}-backup" }
      end

      def delete(name)
        @client.delete "/api/delete", json: { name: name }
      end

      def pull(name:, insecure: nil, &block)
        @client.post "/api/pull", json: { name: name, insecure: insecure, stream: block_given? }.compact, &block
      end

      def push(name:, insecure: nil, &block)
        @client.post "/api/push", json: { name: name, insecure: insecure, stream: block_given? }.compact, &block
      end
    end
  end
end
