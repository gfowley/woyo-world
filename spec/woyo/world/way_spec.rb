require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Way do

  it 'has attributes' do
    expected_attrs = [:name,:description]
    Woyo::Way.attributes.sort.should eq expected_attrs.sort 
  end

  it 'name attribute defaults to id' do
    wo = Woyo::Way.new(:door)
    wo.name.should eq 'Door'
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
                                      
  # these could be handled by a State (and Condition) module ?
  
  it 'may be closed'

  it 'may be open'

  it 'defaults to open'

  it 'may describe going when closed'

  it 'may describe going when open'

  it 'may have a condition for opening'
  
end
