require 'active_support/inflector'

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

  it "replaces spaces with underscores" do
    Benchmark.ips do |x|
      str = Random.new.bytes(1024)

      x.report("tr(' ', '_')") do
        str.tr(' ', '_')
      end

      x.report("gsub(' ', '_')") do
        str.gsub(' ', '_')
      end
    end
  end

  it "dasherizes" do
    Benchmark.ips do |x|
      str = Random.new.bytes(1024)

      x.report("dasherize") do
        str.dasherize
      end

      x.report("tr('_', '-')") do
        str.tr('_', '-')
      end

      x.report("gsub('_', '-')") do
        str.gsub('_', '-')
      end
    end
  end
end
