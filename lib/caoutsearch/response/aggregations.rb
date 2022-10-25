# frozen_string_literal: true

module Caoutsearch
  module Response
    class Aggregations < Caoutsearch::Response::Response
      disable_warnings

      def initialize(original, search)
        @original_search = search
        super(original)
      end
    end
  end
end