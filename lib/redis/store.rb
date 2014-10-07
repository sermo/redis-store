require 'redis/store/ttl'
require 'redis/store/interface'

class Redis
  class Store < self
    include Ttl, Interface

    def initialize(options = {})
      super
      _extend_marshalling(options)
      _extend_namespace(options)
    end

    def get(key, options = nil)
      with_connection_error_handling { super }
    end

    def mget(*keys)
      with_connection_error_handling { super } || []
    end

    def reconnect
      @client.reconnect
    end

    def set(key, value, options = nil)
      with_connection_error_handling { super }
    end

    def setex(key, expiry, value, options = nil)
      with_connection_error_handling { super }
    end

    def setnx(key, value, options = nil)
      with_connection_error_handling { super }
    end

    def to_s
      "Redis Client connected to #{@client.host}:#{@client.port} against DB #{@client.db}"
    end

    private

    def _extend_marshalling(options)
      # HACK - TODO delegate to Factory
      @marshalling = !(options[:marshalling] === false)
      extend Marshalling if @marshalling
    end

    def _extend_namespace(options)
      @namespace = options[:namespace]
      extend Namespace if @namespace
    end

    def log_error(error)
      if defined?(Rails.logger)
        Rails.logger.error(error)
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
