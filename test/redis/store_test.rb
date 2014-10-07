require 'test_helper'

describe Redis::Store do
  before do
    @store = new_store
    @client = get_client(@store)
  end

  it 'returns useful information about the server' do
    @store.to_s.must_equal("Redis Client connected to #{@client.host}:#{@client.port} against DB #{@client.db}")
  end

  it 'must force client reconnection' do
    @client.expects(:reconnect)

    @store.reconnect
  end

  describe 'must not double marshal' do
    before do
      @store = new_store

      Marshal.expects(:dump).once
    end

    it '#set' do
      @store.set('key', 'value')
    end

    it '#setex' do
      @store.setex('key', 1, 'value')
    end

    it '#setnx' do
      @store.setnx('key', 'value')
    end
  end

  private

  def get_client(store)
    store.instance_variable_get(:@client)
  end

  def new_store(client = nil)
    Redis::Store.new.tap do |store|
      set_client(store, client) if client
    end
  end

  def set_client(store, client)
    store.instance_variable_set(:@client, client)
  end
end
