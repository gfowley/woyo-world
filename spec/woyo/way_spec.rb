require 'woyo/way'

describe Woyo::Way do

  context '#new' do

    it 'initializes with symbol id' do
      expect { Woyo::Way.new :my_id }.to_not raise_error
    end

    it 'creates id' do
      Woyo::Way.new(:my_id).id.should eq :my_id
    end

    it 'converts id to lowercase' do
      Woyo::Way.new(:MY_id ).id.should eq :my_id
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::Way.new( :door ) { result = 'ok' }
      result.should eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::Way.new( :door ) { self.class.should == Woyo::Way }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::Way.new( :door ) { |loc| result = 'ok' }
      result.should eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::Way.new( :door ) { |loc| loc.should be_instance_of Woyo::Way }
    end

  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      door = Woyo::Way.new( :door )
      result = door.evaluate { self.should == door }
      result.should be door
    end

    it 'passes self to block with arity 1' do
      door = Woyo::Way.new( :door )
      result = door.evaluate { |loc| loc.should be door }
      result.should be door
    end

  end

  context 'attributes' do

    it 'names can be listed for class' do
      attrs = Woyo::Way.attributes
      attrs.should be_instance_of Array
      attrs.all? { |a| a.is_a? Symbol }.should be_true
    end                       

    it 'names and values can be listed for instance' do
      door = Woyo::Way.new :door
      door.attributes.should be_instance_of Hash
    end

    it 'can be written with =' do
      door = Woyo::Way.new :door
      Woyo::Way.attributes.each do |attr|
        eval "door.#{attr} = '#{attr}'.upcase"
      end
      door.attributes.count.should eq Woyo::Way.attributes.count
      door.attributes.each do |name,value|
        value.should eq name.to_s.upcase
      end
    end

    it 'can be written without =' do
      door = Woyo::Way.new :door
      Woyo::Way.attributes.each do |attr|
        eval "door.#{attr} '#{attr}'.upcase"
      end
      door.attributes.count.should eq Woyo::Way.attributes.count
      door.attributes.each do |name,value|
        value.should eq name.to_s.upcase
      end
    end

    it 'can be read' do
      door = Woyo::Way.new :door
      Woyo::Way.attributes.each do |attr|
        eval "door.#{attr} '#{attr}'.upcase"
      end
      door.attributes.count.should eq Woyo::Way.attributes.count
      door.attributes.each do |name,value|
        eval("door.#{name}").should eq value
      end
    end

  end

end
