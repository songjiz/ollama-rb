# frozen_string_literal: true

require "net/https"
require "json"
require "uri"
require_relative "response"

module Ollama
  class Connection
    def initialize(base_url, logger: nil, **options)
      @base_uri = URI.parse(base_url.to_s)
      @logger   = logger
      @options  = options
    end

    def post(path, json: nil, headers: {}, **options)
      http    = new_http
      request = Net::HTTP::Post.new(path)
      set_request_headers request, default_headers.merge(headers)
      request.body = JSON.generate(json) if json

      return Response.new(http.request(request)) unless block_given?

      result = []
      response = http.request(request) do |http_response|
        # Raises if response is not successful
        # http_response.value
        http_response.read_body do |chunk|
          parsed = JSON.parse(chunk)
          result << parsed
          yield parsed
        end
      end

      Response.new(response).tap { |resp| resp.result = result }
    end

    def get(path, params: {}, headers: {}, **options)
      http    = new_http
      query   = URI.encode_www_form(params)
      uri     = URI.parse(path).tap { |uri| uri.query = query if query.length > 0 }
      request = Net::HTTP::Get.new(uri.to_s)
      set_request_headers request, default_headers.merge(headers)
      Response.new http.request(request)
    end

    def delete(path, json: nil, headers: {}, **options)
      http    = new_http
      request = Net::HTTP::Delete.new(path)
      set_request_headers request, default_headers.merge(headers)
      request.body = JSON.generate(json) if json

      Response.new http.request(request)
    end

    def head(path, headers: {}, **options)
      http    = new_http
      request = Net::HTTP::Head.new(path)
      set_request_headers request, default_headers.merge(headers)
      Response.new http.request(request)
    end

    private
      def new_http
        Net::HTTP.new(@base_uri.host, @base_uri.port).tap do |http|
          http.set_debug_output @logger if @logger
        end
      end

      def default_headers
        {
          "User-Agent" => USER_AGENT
        }
      end

      def set_request_headers(request, headers)
        request.tap do
          headers.each do |key, value|
            request[key] = value
          end
        end
      end
  end
end
