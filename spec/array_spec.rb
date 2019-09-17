require "spec_helper"
require "active_support"
require "active_support/core_ext"

RSpec.describe Array do
  it "value reject" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report("reject") do
        ary10k.reject { |i| i <= 5000 }
      end
      x.report("reject!") do
        ary10k.reject! { |i| i <= 5000 }
      end
      x.report("delete_if") do
        ary10k.delete_if { |i| i <= 5000 }
      end
      x.compare!
    end
  end

  it "blocklist removal" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a
      ary5k = (-5_000..5_000).to_a

      x.report("reject include") do
        ary10k.reject { |i| ary5k.include? i }
      end
      x.report("reject! include") do
        ary10k.reject! { |i| ary5k.include? i }
      end
      x.report("delete_if include") do
        ary10k.delete_if { |i| ary5k.include? i }
      end
      x.report("-=") do
        ary10k -= ary5k
      end
      x.compare!
    end
  end

  it "flatten and unique" do
    Benchmark.ips do |x|
      ary5k1k = (1..5_000).map { |a| (1..10_000).to_a.sample(1000) }

      x.report("flatten.uniq") do
        # because we do an inline in others, have to dup first
        ary5k1k.dup.flatten.uniq
      end
      x.report("flatten!;uniq!") do
        a = ary5k1k.dup
        a.flatten!
        a.uniq!
      end
      x.report("union") do
        ary5k1k.dup.reduce(:|)
      end

      x.compare!
    end
  end

  it "unique" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report("to_s.to_a") do
        ary10k.to_set.to_a
      end
      x.report("uniq") do
        ary10k.uniq
      end
      x.report("uniq!") do
        ary10k.uniq!
      end
      x.compare!
    end
  end

  it "uniq vs union" do
    Benchmark.ips do |x|
      ary1k = (1..10_000).to_a.sample(1000)
      num = 100

      x.report("Array.concat.uniq") do
        ary = []
        num.times do
          ary1k.each { |i| ary.concat([i]) }
        end
        ary.uniq
      end

      x.report("Array.|") do
        ary = []
        num.times do
          ary1k.each { |i| ary |= [i] }
        end
      end

      x.report("Array.concat.|") {
        ary = []
        num.times do
          ary1k.each { |i| ary.concat([i]) }
        end
        ary |= ary
      }
    end
  end

  it "uniq vs set" do
    Benchmark.ips do |x|
      ary1k = (1..10_000).to_a.sample(1000)
      num = 100

      x.report("Array.uniq") do
        ary = []
        num.times do
          ary1k.each { |i| ary << i }
        end
        ary.uniq
      end

      x.report("Set.<<") {
        ary = Set.new
        num.times do
          ary1k.each { |i| ary << i }
        end
      }
    end
  end

  it "times map vs Array.new" do
    Benchmark.ips do |x|
      x.report("times.map") { 5.times.map {} }
      x.report("Array.new") { Array.new(5) {} }
      x.compare!
    end
  end

  it "present" do
    Benchmark.ips do |x|
      empty10k = Array.new(10_000)

      x.report("present?") do
        empty10k.present?
      end
      x.report("any?") do
        empty10k.any?
      end
      x.compare!
    end
  end
end
