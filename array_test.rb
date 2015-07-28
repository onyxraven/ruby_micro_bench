require 'bundler/setup'

def test_value_rejection
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

def test_blacklist_removal
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
