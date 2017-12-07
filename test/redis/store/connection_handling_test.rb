require 'test_helper'

describe Redis::Store do
  def setup
    @store  = Redis::Store.new.tap do |store|
      store.instance_variable_set(:@client, ::Redis::Client.new(port: 12345))
    end
  end

  describe '#get' do
    it 'should log and return nil' do
      @store.expects(:log_error).once
      assert_nil @store.get('key')
    end
  end

  describe '#mget' do
    it 'should log and return empty array' do
      @store.expects(:log_error).once
      @store.mget('key1', 'key2').must_equal([])
    end
  end

  describe '#set' do
    it 'should log and return nil' do
      @store.expects(:log_error).once
      assert_nil @store.set('key', 'value')
    end
  end

  describe '#setex' do
    it 'should log and return nil' do
      @store.expects(:log_error).once
      assert_nil @store.setex('key', 1, 'value')
    end
  end

  describe '#setnx' do
    it 'should log and return nil' do
      @store.expects(:log_error).once
      @store.setnx('key', 'value').must_equal(false)
    end
  end

  describe '#flushdb' do
    it 'should log an error' do
      @store.expects(:log_error).once
      @store.flushdb
    end
  end
end
