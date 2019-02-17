require 'active_support'
require 'active_support/inflector'
require 'faker'

RSpec.describe Symbol do

  it "symbol to_sym" do
    Benchmark.ips do |x|
      sym = Faker::Internet.user_name(nil, %w(_)).to_sym

      x.report("self") do
        _ = sym
      end

      x.report("to_sym") do
        _ = sym.to_sym
      end

      x.report("to_s") do
        _ = sym.to_s
      end

      x.report('conditional') do
        sym = sym.to_sym unless sym.is_a?(Symbol)
      end
    end
  end
end
