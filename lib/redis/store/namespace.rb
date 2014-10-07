class Redis
  class Store < self
    module Namespace
      def decrby(key, increment)
        namespace(key) { |k| super(k, increment) }
      end

      def del(*keys)
        super(*keys.map { |k| interpolate(k) }) if keys.any?
      end

      def exists(key)
        namespace(key) { |k| super(k) }
      end

      def expire(key, ttl)
        namespace(key) { |k| super(k, ttl) }
      end

      def flushdb
        del(*keys)
      end

      def get(key, options = nil)
        namespace(key) { |k| super(k, options) }
      end

      def incrby(key, increment)
        namespace(key) { |k| super(k, increment) }
      end

      def keys(pattern = "*")
        namespace(pattern) { |p| super(p).map { |k| strip_namespace(k) } }
      end

      def mget(*keys)
        super(*keys.map { |k| interpolate(k) }) if keys.any?
      end

      def set(key, value, options = nil)
        namespace(key) { |k| super(k, value, options) }
      end

      def setnx(key, value, options = nil)
        namespace(key) { |k| super(k, value, options) }
      end

      def to_s
        "#{super} with namespace #{@namespace}"
      end

      def ttl(key)
        namespace(key) { |k| super(k) }
      end

      private

      def interpolate(key)
        key.match(namespace_regexp) ? key : "#{@namespace}:#{key}"
      end

      def namespace(key)
        yield interpolate(key)
      end

      def namespace_regexp
        @namespace_regexp ||= %r{^#{@namespace}\:}
      end

      def strip_namespace(key)
        key.gsub(namespace_regexp, "")
      end
    end
  end
end
