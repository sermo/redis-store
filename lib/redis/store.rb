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
      super
    end

    def reconnect
      @client.reconnect
    end

    def set(key, value, options = nil)
      super
    end

    def setex(key, expiry, value, options = nil)
      super
    end

    def setnx(key, value, options = nil)
      super
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
  end
end
