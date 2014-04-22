require 'woyo/world'

describe Woyo::World do

  it 'initializes with no locations' do
    Woyo::World.new.locations.should be_empty
  end

  it 'initializes with no characters' do
    Woyo::World.new.characters.should be_empty
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
      home = world.location( :home ) { result = 'ok' }
      home.should be_instance_of Woyo::Location
      result.should eq 'ok'
    end

    it 'accepts a block with arity 1 for new location' do
      world = Woyo::World.new
      result = ''
      home = world.location( :home ) { |loc| result = 'ok' }
      home.should be_instance_of Woyo::Location
      result.should eq 'ok'
    end

    it 'accepts a block with arity 0 for existing location' do
      world = Woyo::World.new
      home = world.location( :home ) { |loc| loc._test = 'ok' }
      home.should be_instance_of Woyo::Location
      result = ''
      other = world.location( :home ) { result = @_test }
      other.should be home
      result.should eq 'ok'
    end

    it 'accepts a block with arity 1 for existing location' do
      world = Woyo::World.new
      home = world.location( :home ) { @_test = 'ok' }
      home.should be_instance_of Woyo::Location
      result = ''
      other = world.location( :home ) { |loc| result = loc._test }
      other.should be home
      result.should eq 'ok'
    end

  end

  context '#character' do

    it 'creates new character' do
      world = Woyo::World.new
      home = world.character :batman
      away = world.character :robin
      world.characters.size.should eq 2
      world.characters[:batman].should be home
      world.characters[:robin].should be away
    end

    it 'adds existing character' do
      world = Woyo::World.new
      home = world.character Woyo::Character.new :batman
      away = world.character Woyo::Character.new :robin
      world.characters.size.should eq 2
      world.characters[:batman].should be home
      world.characters[:robin].should be away
    end

    it 'accepts a block with arity 0 for new character' do
      world = Woyo::World.new
      result = ''
      home = world.character( :batman ) { result = 'ok' }
      home.should be_instance_of Woyo::Character
      result.should eq 'ok'
    end

    it 'accepts a block with arity 1 for new character' do
      world = Woyo::World.new
      result = ''
      home = world.character( :batman ) { |char| result = 'ok' }
      home.should be_instance_of Woyo::Character
      result.should eq 'ok'
    end

    it 'accepts a block with arity 0 for existing character' do
      world = Woyo::World.new
      home = world.character( :batman ) { |char| char._test = 'ok' }
      home.should be_instance_of Woyo::Character
      result = ''
      other = world.character( :batman ) { result = @_test }
      other.should be home
      result.should eq 'ok'
    end

    it 'accepts a block with arity 1 for existing character' do
      world = Woyo::World.new
      home = world.character( :batman ) { @_test = 'ok' }
      home.should be_instance_of Woyo::Character
      result = ''
      other = world.character( :batman ) { |char| result = char._test }
      other.should be home
      result.should eq 'ok'
    end

  end

end
