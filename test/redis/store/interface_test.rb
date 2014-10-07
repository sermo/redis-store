require 'test_helper'

class InterfacedRedis < Redis
  include Redis::Store::Interface
end

describe Redis::Store::Interface do
  before do
    @r = InterfacedRedis.new
  end

  it 'should get an element' do
    @r.get('key')
  end

  it 'should set an element' do
    @r.set('key', 'value')
  end

  it 'should setex an element' do
    @r.setex('key', 1, 'value')
  end

  it 'should setnx an element' do
    @r.setnx('key', 'value')
  end
end
