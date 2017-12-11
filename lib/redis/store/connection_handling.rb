class Redis
  class Store < self
    module ConnectionHandling
      def get(key, options = nil)
        with_connection_error_handling { super }
      end

      def mget(*keys)
        with_connection_error_handling { super } || []
      end

      def set(key, value, options = nil)
        with_connection_error_handling { super }
      end

      def setex(key, expiry, value, options = nil)
        with_connection_error_handling { super }
      end

      def setnx(key, value, options = nil)
        with_connection_error_handling { super } || false
      end

      def flushdb
        with_connection_error_handling { super }
      end

      private

      def log_error(error)
        if defined?(::Rails.logger)
          ::Rails.logger.error(error)
        else
          STDERR.puts(error)
        end
      end

      def message_for_exception(exception)
        "%s:\n%s" % [
          exception.message,
          exception.backtrace.map { |line| "\tfrom #{line}" }.join("\n"),
        ]
      end

      def with_connection_error_handling
        yield
      rescue Redis::CannotConnectError => exception
        log_error(message_for_exception(exception))
      end
    end
  end
end
