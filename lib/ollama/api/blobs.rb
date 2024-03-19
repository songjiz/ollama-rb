# frozen_string_literal: true

module Ollama
  module API
    class Blobs
      def initialize(client:)
        @client = client
      end

      def create(digest)
        @client.post "/api/blobs/#{digest}"
      end

      def exists?(digest)
        response = @client.head "/api/blobs/#{digest}"
        response.ok?
      end
    end
  end
end
