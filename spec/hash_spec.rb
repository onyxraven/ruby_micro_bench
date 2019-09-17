# define any extensions we want to test too
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
  it "iterate all values" do
    Benchmark.ips do |x|
      hsh = Hash[10000.times.map { |i| [i.to_s, i] }]
      x.report("val.each") do
        sum = 0
        hsh.dup.values.each { |n| sum += n }
      end
      x.report("each_val") do
        sum = 0
        hsh.dup.each_value { |n| sum += n }
      end
      x.report("each") do
        sum = 0
        hsh.dup.each { |_, n| sum += n }
      end
      x.compare!
    end
  end

  it "flatten unique values" do
    Benchmark.ips do |x|
      hsh = Hash[(1..10_000).map { |a| [a, (1..1_000).to_a.sample(100)] }]

      x.report("values.flatten.uniq") do
        # because we do an inline in others, have to dup first
        hsh.values.flatten.uniq
      end
      x.report("values.flatten!.uniq!") do
        # because we do an inline in others, have to dup first
        h = hsh.values
        h.flatten!
        h.uniq!
      end
      x.report("flat_map.uniq") do
        hsh.flat_map { |_, v| v }.uniq
      end
      x.report("flat_map.uniq!") do
        h = hsh.flat_map { |_, v| v }
        h.uniq!
      end

      x.compare!
    end
  end

  it "construct from enumerable" do
    Benchmark.ips(warmup: 5, time: 10) do |x|
      list = (1..10_000).map { |a| {id: a, value: rand(10_000)} }

      x.report("Hash[]") do
        Hash[list.map { |i| [i[:id], i] }]
      end

      x.report("to_h") do
        list.map { |i| [i[:id], i] }.to_h
      end

      x.report("each_with_object") do
        list.each_with_object({}) { |arg, memo| memo[arg[:id]] = arg }
      end

      x.report("reduce") do
        list.each_with_object({}) { |arg, memo| memo[arg[:id]] = arg; }
      end

      x.report("index_hashes_by_id") do
        list.index_hashes_by_id
      end

      x.compare!
    end
  end

  it "block vs direct call" do
    Benchmark.ips(warmup: 5, time: 10) do |x|
      list = (1..10_000).map { |a| {id: a, value: rand(10_000)} }

      x.report("index_hashes_by_id call block") do
        list.index_hashes_by_id { |i| i[:value] * 3 }
      end

      x.report("each_with_object direct") do
        list.each_with_object({}) { |arg, memo| memo[arg[:id]] = arg[:value] * 3 }
      end

      x.compare!
    end
  end
end
