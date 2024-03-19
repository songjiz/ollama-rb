# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ollama"

require "minitest/autorun"
require 'webmock/minitest'

# Mock body streaming for Net::HTTP
# See https://github.com/bblimke/webmock/pull/1051
module Net
  module WebMockHTTPResponse
    def read_body(dest = nil, &block)
      if !(defined?(@__read_body_previously_called).nil?) && @__read_body_previously_called
        return super
      end
      return @body if dest.nil? && block.nil?
      raise ArgumentError.new("both arg and block given for HTTP method") if dest && block
      return nil if @body.nil?

      dest ||= ::Net::ReadAdapter.new(block)
      if @body.is_a?(Array)
        @body.each { |part| dest << part.dup }
      else
        dest << @body.dup
      end
      @body = dest
    ensure
      # allow subsequent calls to #read_body to proceed as normal, without our hack...
      @__read_body_previously_called = true
    end
  end
end
