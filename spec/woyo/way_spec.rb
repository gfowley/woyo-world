require 'woyo/world'
require 'woyo/location'
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
    
    it 'accepts location for parameter context:' do
      expect { Woyo::Way.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
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

  it '#from' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here
    door.from.should eq here
  end

  it '#location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here
    door.from.should eq here
  end

  it '#world' do
    world = Woyo::World.new
    here = Woyo::Location.new :here, context: world
    door = Woyo::Way.new :door, context: here
    door.world.should eq world
  end

end
