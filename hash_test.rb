def test_value_iteration
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
