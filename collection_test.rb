require 'bundler/setup'

def test_value_deduplication
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