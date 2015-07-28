require 'bundler/setup'

def test_value_rejection
  Benchmark.ips do |x|
    ary10k = (1..10_000).to_a
    ary5k = (1..5_000).to_a

    x.report('reject') {
      ary10k.reject { |i| i <= 5000 }
    }
    x.report('reject!') {
      ary10k.reject! { |i| i <= 5000 }
    }
    x.report('delete_if') {
      ary10k.delete_if { |i| i <= 5000 }
    }

    # note: this behavior is slightly different
    # since it doesn't use a block
    # but reflects the case of a known 'blacklist'
    x.report('-=') {
      ary10k -= ary5k
    }
    x.compare!
  end
end
