# frozen_string_literal: true

module Caoutsearch
  module Response
    class Aggregations < Caoutsearch::Response::Response
      disable_warnings

      def initialize(aggs, search = nil, &block)
        @source_search = search
        super(aggs, &block)
      end

      def key?(key)
        super || has_transformation?(key)
      end

      def custom_reader(key)
        if has_transformation?(key)
          transformation_cache(key) do
            call_transformation(key)
          end
        else
          super
        end
      end

      alias_method :[], :custom_reader

      def has_transformation?(key)
        @source_search&.class&.transformations&.include?(key.to_s)
      end

      private

      def call_transformation(key)
        item = @source_search.class.transformations.fetch(key.to_s)
        aggs = @source_search.response.aggregations

        @source_search.instance_exec(aggs, &item.block)
      end

      def transformation_cache(name)
        @cached_transformations ||= {}
        return @cached_transformations[name] if @cached_transformations.include?(name)

        @cached_transformations[name] = yield
      end
    end
  end
end
