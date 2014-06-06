require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Way do

  let(:way) { Woyo::Way.new :door }

  it 'has attributes' do
    way.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    way.attributes.names.sort.should eq [:closed,:description,:going,:name,:open]
  end

  it 'name attribute defaults to id' do
    way.name.should eq 'Door'
  end

  it 'accepts location for parameter context:' do
    wo = nil
    expect { wo = Woyo::Way.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
    wo.context.should be_instance_of Woyo::Location
    wo.context.id.should eq :here
  end

  it 'is in a world' do
    world = Woyo::World.new
    here = Woyo::Location.new :here, context: world
    door = Woyo::Way.new :door, context: here
    door.world.should eq world
  end

  it 'leads from a location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here
    door.from.should eq here
  end

  it 'leads to a location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here do
      to :away
    end
    door.to.should be_a Woyo::Location
  end
                                      
  it 'defaults to closed if "to" not defined' do
    door = Woyo::Way.new(:door)
    door.open.should be_false
    door.closed.should be_true
  end

  it 'defaults to open if "to" defined' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    door.open.should be_true
    door.closed.should be_false
  end

  it 'may be made closed' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    door.open.should be_true
    door.closed.should be_false
    door.closed = true
    door.open.should be_false
    door.closed.should be_true
  end

  it 'may be made open' do
    door = Woyo::Way.new(:door)
    door.open.should be_false
    door.closed.should be_true
    door.open = true
    door.open.should be_true
    door.closed.should be_false
  end

  it 'may be closed!' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    door.open.should be_true
    door.closed.should be_false
    door.close!
    door.open.should be_false
    door.closed.should be_true
  end

  it 'can close!' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    door.open.should be_true
    door.closed.should be_false
    door.close!
    door.open.should be_false
    door.closed.should be_true
  end

  it 'can open!' do
    door = Woyo::Way.new(:door)
    door.open.should be_false
    door.closed.should be_true
    door.open!
    door.open.should be_true
    door.closed.should be_false
  end

  it 'query open?' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    door.should be_open
    door.close!
    door.should_not be_open
  end

  it 'query closed?' do
    door = Woyo::Way.new(:door)
    door.should be_closed
    door.open!
    door.should_not be_closed
  end
  
  context 'description' do

    before :all do
      @door = Woyo::Way.new(:door)
      @door.to = :someplace
    end

    it 'can be described' do
      @door.description = 'Just a door'
      @door.description.should eq 'Just a door'
    end

    it 'can be described open' do
      @door.description open: 'An open door', closed: 'A closed door'
      @door.description.should eq 'An open door'
    end

    it 'can be described closed' do
      @door.close!
      @door.description.should eq 'A closed door'
    end

  end

  context 'going' do

    before :all do
      @door = Woyo::Way.new(:door)
      @door.to :someplace
      @door.going :open => 'Swings open', :closed => 'Slams shut'
    end

    it 'when open' do
      @door.go.should eq ( { go: true, going: 'Swings open' } )
    end

    it 'when closed' do
      @door.close!
      @door.go.should eq ( { go: false, going: 'Slams shut' } )
    end

  end

end
