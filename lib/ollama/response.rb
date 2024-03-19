# frozen_string_literal: true

require "forwardable"
require "json"

module Ollama
  class Response
    extend Forwardable
    def_delegators :@http_response, :code, :body

    def initialize(http_response)
      @http_response = http_response
    end

    def ok?
      code == "200"
    end

    def error?
      !ok?
    end

    def result=(value)
      @result = value
    end

    def result
      @result ||= JSON.parse(body) rescue {}
    end
  end
end
