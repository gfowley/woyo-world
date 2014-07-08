require 'spec_helper'
require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Way do

  let(:way) { Woyo::Way.new :door }

  context 'has attributes' do

    it ':open' do
      expect(way.attributes.names).to include :open
    end

    it ':closed' do
      expect(way.attributes.names).to include :closed
    end

    it ':going' do
      expect(way.attributes.names).to include :going
    end

  end

  it 'accepts location for parameter context:' do
    wo = nil
    expect { wo = Woyo::Way.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
    expect(wo.context).to be_instance_of Woyo::Location
    expect(wo.context.id).to eq :here
  end

  it 'is in a world' do
    world = Woyo::World.new
    here = Woyo::Location.new :here, context: world
    door = Woyo::Way.new :door, context: here
    expect(door.world).to eq world
  end

  it 'leads from a location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here
    expect(door.from).to eq here
  end

  it 'leads to a location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here do
      to :away
    end
    expect(door.to).to be_a Woyo::Location
  end
                                      
  it 'defaults to closed if "to" not defined' do
    door = Woyo::Way.new(:door)
    expect(door.open).to be false
    expect(door.closed).to be true
  end

  it 'defaults to open if "to" defined' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    expect(door.open).to be true
    expect(door.closed).to be false
  end

  it 'may be made closed' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    expect(door.open).to be true
    expect(door.closed).to be false
    door.closed = true
    expect(door.open).to be false
    expect(door.closed).to be true
  end

  it 'may be made open' do
    door = Woyo::Way.new(:door)
    expect(door.open).to be false
    expect(door.closed).to be true
    door.open = true
    expect(door.open).to be true
    expect(door.closed).to be false
  end

  it 'may be closed!' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    expect(door.open).to be true
    expect(door.closed).to be false
    door.close!
    expect(door.open).to be false
    expect(door.closed).to be true
  end

  it 'can close!' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    expect(door.open).to be true
    expect(door.closed).to be false
    door.close!
    expect(door.open).to be false
    expect(door.closed).to be true
  end

  it 'can open!' do
    door = Woyo::Way.new(:door)
    expect(door.open).to be false
    expect(door.closed).to be true
    door.open!
    expect(door.open).to be true
    expect(door.closed).to be false
  end

  it 'query open?' do
    door = Woyo::Way.new(:door)
    door.to = :someplace
    expect(door).to be_open
    door.close!
    expect(door).not_to be_open
  end

  it 'query closed?' do
    door = Woyo::Way.new(:door)
    expect(door).to be_closed
    door.open!
    expect(door).not_to be_closed
  end
  
  context 'description' do

    before :all do
      @door = Woyo::Way.new(:door)
      @door.to = :someplace
    end

    it 'can be described' do
      @door.description = 'Just a door'
      expect(@door.description).to eq 'Just a door'
    end

    it 'can be described open' do
      @door.description open: 'An open door', closed: 'A closed door'
      expect(@door.description).to eq 'An open door'
    end

    it 'can be described closed' do
      @door.close!
      expect(@door.description).to eq 'A closed door'
    end

  end

  context 'going' do

    before :all do
      @door = Woyo::Way.new(:door)
      @door.to :someplace
      @door.going :open => 'Swings open', :closed => 'Slams shut'
    end

    it 'when open' do
      expect(@door.go).to eq ( { go: true, going: 'Swings open' } )
    end

    it 'when closed' do
      @door.close!
      expect(@door.go).to eq ( { go: false, going: 'Slams shut' } )
    end

  end

end
