#define any extensions we want to test too
module Enumerable
  def index_hashes_by_id
    if block_given?
      each_with_object({}) { |elem, memo| memo[elem[:id]] = yield(elem) }
    else
      each_with_object({}) { |elem, memo| memo[elem[:id]] = elem }
    end
  end
end

RSpec.describe Hash do

  it 'iterate all values' do
    Benchmark.ips do |x|
      hsh = Hash[10000.times.map {|i| [i.to_s, i]}]
      x.report('val.each') {
        sum = 0
        hsh.dup.values.each {|n| sum += n}
      }
      x.report('each_val') {
        sum = 0
        hsh.dup.each_value {|n| sum += n}
      }
      x.report('each') {
        sum = 0
        hsh.dup.each {|_,n| sum += n}
      }
      x.compare!
    end
  end

  it 'flatten unique values' do
    Benchmark.ips do |x|
      hsh = Hash[(1..10_000).map { |a| [a, (1..1_000).to_a.sample(100)] }]

      x.report('values.flatten.uniq') {
        #because we do an inline in others, have to dup first
        hsh.values.flatten.uniq
      }
      x.report('values.flatten!.uniq!') {
        #because we do an inline in others, have to dup first
        h = hsh.values
        h.flatten!
        h.uniq!
      }
      x.report('flat_map.uniq') {
        hsh.flat_map { |_,v| v }.uniq
      }
      x.report('flat_map.uniq!') {
        h = hsh.flat_map { |_,v| v }
        h.uniq!
      }

      x.compare!
    end
  end

  it 'construct from enumerable' do
    Benchmark.ips(warmup: 5, time: 10) do |x|
      list = (1..10_000).map { |a| { id: a, value: rand(10_000) } }

      x.report('Hash[]') {
        Hash[list.map { |i| [i[:id], i] }]
      }

      x.report('to_h') {
        list.map { |i| [i[:id], i] }.to_h
      }

      x.report('each_with_object') {
        list.each_with_object({}) { |arg, memo| memo[arg[:id]] = arg }
      }

      x.report('reduce') {
        list.reduce({}) { |memo, arg| memo[arg[:id]] = arg; memo }
      }

      x.report('index_hashes_by_id') {
        list.index_hashes_by_id
      }

      x.compare!
    end
  end

  it 'block vs direct call' do
    Benchmark.ips(warmup: 5, time: 10) do |x|
      list = (1..10_000).map { |a| { id: a, value: rand(10_000) } }

      x.report('index_hashes_by_id call block') {
        list.index_hashes_by_id { |i| i[:value] * 3 }
      }

      x.report('each_with_object direct') {
        list.each_with_object({}) { |arg, memo| memo[arg[:id]] = arg[:value] * 3 }
      }

      x.compare!
    end
  end

end
