require 'woyo/world'

describe Woyo::World do

  context '#new' do
    
    it 'initializes' do
      expect { Woyo::World.new }.to_not raise_error
    end

    it 'initializes with no locations' do
      Woyo::World.new.locations.should be_empty
    end

    it 'initializes with no items' do
      Woyo::World.new.items.should be_empty
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::World.new { result = 'ok' }
      result.should eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::World.new { self.class.should == Woyo::World }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::World.new { |wor| result = 'ok' }
      result.should eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::World.new { |wor| wor.should be_instance_of Woyo::World }
    end

  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      Woyo::World.new.evaluate { self.class.should == Woyo::World }
    end

    it 'passes self to block with arity 1' do
      Woyo::World.new.evaluate { |wor| wor.should be_instance_of Woyo::World }
    end

  end

  context '#location' do

    it 'creates new location' do
      world = Woyo::World.new
      home = world.location :home
      away = world.location :away
      world.locations.size.should eq 2
      world.locations[:home].should be home
      world.locations[:away].should be away
    end

    it 'adds existing location' do
      world = Woyo::World.new
      home = world.location Woyo::Location.new :home
      away = world.location Woyo::Location.new :away
      world.locations.size.should eq 2
      world.locations[:home].should be home
      world.locations[:away].should be away
    end

    it 'accepts a block with arity 0 for new location' do
      world = Woyo::World.new
      result = ''
      world.location( :home ) { result = 'ok' }
      result.should eq 'ok'
    end

    it 'accepts a block with arity 1 for new location' do
      world = Woyo::World.new
      result = ''
      world.location( :home ) { |loc| result = 'ok' }
      result.should eq 'ok'
    end

    it 'accepts a block with arity 0 for existing location'

    it 'accepts a block with arity 1 for existing location'

  end

end
