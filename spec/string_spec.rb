RSpec.describe String do

  it 'iterate chars' do
    Benchmark.ips do |x|
      str = Random.new.bytes(1024)

      i = 0
      x.report('split') {
        str.split('').each { |c| i += 1 }
      }
      x.report('scan') {
        str.scan(/./) { |c| i += 1 }
      }
      x.report('each_char') {
        str.each_char { |c| i += 1 }
      }
      x.report('each_byte') {
        #trick is it is doing character.chr, but sometimes thats what you want anyway
        str.each_byte { |c| i += 1 }
      }
      x.report('at index for') {
        for pos in 0..str.length - 1
          c = str[pos]; i += 1
        end
      }
      x.report('at index each') {
        (0..str.length - 1).each { |n| c = str[n]; i += 1 }
      }
    end
  end

end
