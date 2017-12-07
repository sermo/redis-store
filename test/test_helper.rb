require 'bundler/setup'
require 'minitest/autorun'
require 'mocha/setup'
require 'redis'
require 'redis-store'
require 'pry'

$DEBUG = ENV["DEBUG"] === "true"

Redis::DistributedStore.send(:class_variable_set, :@@timeout, 30)

# http://mentalized.net/journal/2010/04/02/suppress_warnings_from_ruby/
module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end

def extract_pid(line)
  line.split[1].to_i
end

def get_redis_processes(port)
  `ps aux | grep [r]edis-server | grep #{port}`.split("\n")
end

def ports_to_kill
  @ports_to_kill ||= []
end

def ports_to_start
  [6379, 6380, 6381]
end

def redis_binary
  @redis_binary ||= `which redis-server`.strip
  abort 'Could not locate redis-server binary' unless @redis_binary
  @redis_binary
end

def start_redis(port)
  pid = spawn(%{(echo "port #{port}" | #{redis_binary} -) > /dev/null 2>&1})
  abort "Could not start redis-server on port #{port}" unless pid
  ports_to_kill << port
end

def stop_redis(port)
  get_redis_processes(port).each do |line|
    pid = extract_pid(line)
    abort "Could not extract pid from line:\n#{line}" unless pid
    Process.kill('TERM', pid)
  end
end

ports_to_start.each do |port|
  start_redis(port) if get_redis_processes(port).empty?
end

Minitest.after_run do
  ports_to_kill.each { |port| stop_redis(port) }
end
