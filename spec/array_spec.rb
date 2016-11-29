require 'spec_helper'
require 'active_support/core_ext'

RSpec.describe Array do
  it "value reject" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report('reject') {
        ary10k.reject { |i| i <= 5000 }
      }
      x.report('reject!') {
        ary10k.reject! { |i| i <= 5000  }
      }
      x.report('delete_if') {
        ary10k.delete_if { |i| i <= 5000 }
      }
      x.compare!
    end
  end

  it "blacklist removal" do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a
      ary5k = (-5_000..5_000).to_a

      x.report('reject include') {
        ary10k.reject { |i| ary5k.include? i }
      }
      x.report('reject! include') {
        ary10k.reject! { |i| ary5k.include? i }
      }
      x.report('delete_if include') {
        ary10k.delete_if { |i| ary5k.include? i }
      }
      x.report('-=') {
        ary10k -= ary5k
      }
      x.compare!
    end
  end

  it 'flatten and unique' do
    Benchmark.ips do |x|
      ary5k1k = (1..5_000).map { |a| (1..10_000).to_a.sample(1000) }

      x.report('flatten.uniq') {
        #because we do an inline in others, have to dup first
        ary5k1k.dup.flatten.uniq
      }
      x.report('flatten!;uniq!') {
        a = ary5k1k.dup
        a.flatten!
        a.uniq!
      }
      x.report('union') {
        ary5k1k.dup.reduce(:|)
      }

      x.compare!
    end
  end

  it 'unique' do
    Benchmark.ips do |x|
      ary10k = (1..10_000).to_a

      x.report('to_s.to_a') {
        ary10k.to_set.to_a
      }
      x.report('uniq') {
        ary10k.uniq
      }
      x.report('uniq!') {
        ary10k.uniq!
      }
      x.compare!
    end
  end

  it 'uniq vs union' do
    Benchmark.ips do |x|
      ary1k = (1..10_000).to_a.sample(1000)
      num = 100

      x.report('Array.concat.uniq') {
        ary = []
        num.times do
          ary1k.each { |i| ary.concat([i]) }
        end
        ary.uniq
      }

      x.report('Array.|') {
        ary = []
        num.times do
          ary1k.each { |i| ary |= [i] }
        end
      }

      x.report('Array.concat.|') {
        ary = []
        num.times do
          ary1k.each { |i| ary.concat([i]) }
        end
        ary |= ary
      }
    end
  end

  it 'uniq vs set' do
    Benchmark.ips do |x|
      ary1k = (1..10_000).to_a.sample(1000)
      num = 100

      x.report('Array.uniq') {
        ary = []
        num.times do
          ary1k.each { |i| ary << i }
        end
        ary.uniq
      }

      x.report('Set.<<') {
        ary = Set.new
        num.times do
          ary1k.each { |i| ary << i }
        end
      }

    end
  end

  it 'present' do
    Benchmark.ips do |x|
      empty10k = Array.new(10_000)

      x.report('present?') {
        empty10k.present?
      }
      x.report('any?') {
        empty10k.any?
      }
      x.compare!
    end
  end
end
