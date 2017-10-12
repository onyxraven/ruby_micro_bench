require 'active_support/inflector'
require 'faker'

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
          _ = str[pos]; i += 1
        end
      }
      x.report('at index each') {
        (0..str.length - 1).each { |n| _ = str[n]; i += 1 }
      }
    end
  end

  it "replaces spaces with underscores" do
    Benchmark.ips do |x|
      str = Faker::Name.name

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
      str = Faker::Internet.user_name(nil, %w(_))

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

  it "string to_s" do
    Benchmark.ips do |x|
      str = Faker::Internet.user_name(nil, %w(_))

      x.report("self") do
        _ = str
      end

      x.report("to_s") do
        _ = str.to_s
      end

      x.report("to_sym") do
        _ = str.to_sym
      end

      x.report("dup") do
        _ = str.dup
      end

      x.report('conditional') do
        str = str.to_s unless str.is_a?(String)
      end

    end
  end

  it 'to_sym vs freeze' do
    Benchmark.ips do |x|

      x.report("to_sym") do
        str = Faker::Internet.user_name(nil, %w(_)).dup
        _ = str.to_sym
      end
      x.report("freeze") do
        str = Faker::Internet.user_name(nil, %w(_)).dup
        _ = str.freeze
      end

    end
  end

  it 'freeze if frozen' do
    Benchmark.ips do |x|
      base = Faker::Internet.user_name(nil, %w(_))

      x.report("freeze") do
        str = base.dup
        base.freeze
        _ = str.freeze
      end

      x.report("frozen") do
        str = base.dup.freeze
        _ = str.freeze
      end

      x.report("conditional freeze") do
        str = base.dup
        base.freeze
        _ = str.freeze unless str.frozen?
      end

      x.report("conditional frozen") do
        str = base.dup.freeze
        _ = str.freeze unless str.frozen?
      end

    end
  end
end
