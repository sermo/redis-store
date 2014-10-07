class Redis
  class Store < self
    module Ttl
      def set(key, value, options = nil)
        ttl = expires_in(options)
        if ttl
          setex(key, ttl.to_i, value, :raw => true)
        else
          super(key, value)
        end
      end

      def setnx(key, value, options = nil)
        ttl = expires_in(options)
        if ttl
          setnx_with_expire(key, value, ttl.to_i)
        else
          super(key, value)
        end
      end

      protected

      def setnx_with_expire(key, value, ttl)
        multi do
          setnx(key, value, :raw => true)
          expire(key, ttl)
        end
      end

      private

      def expires_in(options)
        if options
          # Rack::Session
          options[:expire_after] ||
          # Merb
          options[:expires_in] ||
          # Rails/Sinatra
          options[:expire_in]
        end
      end
    end
  end
end
