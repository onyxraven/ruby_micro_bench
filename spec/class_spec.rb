require "spec_helper"

class RawClassTest
  def self.get
    @@var
  end

  def self.set
    @@var = "rawvar"
  end
end

class MetaClassTest
  def self.get(var)
    class_variable_get(var)
  end

  def self.set(var)
    class_variable_set(var, "metavar")
  end
end

RSpec.describe Class do
  it "class var" do
    Benchmark.ips do |x|
      x.report("rawvar getset") do
        RawClassTest.set
        RawClassTest.get
      end

      x.report("meta getset") do
        MetaClassTest.set(:@@var)
        MetaClassTest.get(:@@var)
      end

      x.compare!
    end
  end
end
