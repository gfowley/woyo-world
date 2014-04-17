require 'woyo/location'
require 'woyo/attributes'

describe Woyo::Attributes do

  before :all do
    class AttrTest
      include Woyo::Attributes
      attributes :attr1, :attr2, :attr3
    end
  end
  
  it 'names can be listed for class' do
    attrs = AttrTest.attributes
    attrs.should be_instance_of Array
    attrs.count.should eq 3
    attrs.all? { |a| a.is_a? Symbol }.should be_true
  end                       

  it 'names and values can be retrieved for instance' do
    attrs = AttrTest.new.attributes
    attrs.should be_instance_of Hash
  end

  it 'can be written with =' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      eval "attr_test.#{attr} = '#{attr}'.upcase"
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be written without =' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      eval "attr_test.#{attr} '#{attr}'.upcase"
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be read' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      eval "attr_test.#{attr} '#{attr}'.upcase"
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      eval("attr_test.#{name}").should eq value
    end
  end

end

