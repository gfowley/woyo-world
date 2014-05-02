require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Location do

  it 'has attributes' do
    expected_attrs = [:name,:description]
    Woyo::Location.attributes.sort.should eq expected_attrs.sort 
  end

  it 'accepts world for parameter context:' do
    wo = nil
    expect { wo = Woyo::Location.new(:my_id, context: Woyo::World.new) }.to_not raise_error
    wo.context.should be_instance_of Woyo::World
  end

  context 'ways' do

    it 'are listed (#ways)' do
      home = Woyo::Location.new :home do
        way( :up   ) { to :roof   }
        way( :down ) { to :cellar }
        way( :out  ) { to :garden }
      end
      home.ways.count.should eq 3
      home.ways.keys.should eq [ :up, :down, :out ]
    end

    it 'are from here' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      door.from.should eq home
    end

    it 'go to locations' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      door.to.should be_instance_of Woyo::Location
      door.to.id.should eq :away
    end

  end

  it '#here' do
    home = Woyo::Location.new :home 
    home.here.should be home
  end

  it '#world' do
    world = Woyo::World.new
    home = Woyo::Location.new :home, context: world
    home.world.should eq world
  end

  it '#characters' do
    home = Woyo::Location.new :home do
      character :peter do
      end
    end
    home.characters.size.should eq 1
    peter = home.characters[:peter]
    peter.should be_instance_of Woyo::Character
    peter.location.should be home
  end

end
