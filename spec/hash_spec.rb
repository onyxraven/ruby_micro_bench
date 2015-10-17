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

end
