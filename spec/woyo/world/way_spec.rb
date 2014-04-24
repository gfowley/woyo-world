require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Way do

  it 'accepts location for parameter context:' do
    wo = nil
    expect { wo = Woyo::Way.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
    wo.context.should be_instance_of Woyo::Location
    wo.context.id.should eq :here
  end

  it 'leads from a location' do
    here = Woyo::Location.new(:here)
    door = Woyo::Way.new :door, context: here
    door.from.should eq here
  end

  it 'is in a world' do
    world = Woyo::World.new
    here = Woyo::Location.new :here, context: world
    door = Woyo::Way.new :door, context: here
    door.world.should eq world
  end

end
