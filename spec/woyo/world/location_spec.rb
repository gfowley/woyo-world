require 'spec_helper'
require 'woyo/world/world'
require 'woyo/world/location'
require 'woyo/world/way'

describe Woyo::Location do

  let(:location) { Woyo::Location.new :home }

  it 'has attributes' do
    expect(location.attributes).to be_instance_of Woyo::Attributes::AttributesHash
    expect(location.attributes.names.sort).to eq [:description,:name]
  end

  it 'name attribute defaults to id' do
    expect(location.name).to eq 'Home'
  end

  it 'accepts world for parameter context:' do
    wo = nil
    expect { wo = Woyo::Location.new(:my_id, context: Woyo::World.new) }.to_not raise_error
    expect(wo.context).to be_instance_of Woyo::World
  end

  context 'ways' do

    it 'are listed (#ways)' do
      home = Woyo::Location.new :home do
        way( :up   ) { to :roof   }
        way( :down ) { to :cellar }
        way( :out  ) { to :garden }
      end
      expect(home.ways.count).to eq 3
      expect(home.ways.keys).to eq [ :up, :down, :out ]
    end

    it 'are from here' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      expect(door.from).to eq home
    end

    it 'go to locations' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      expect(door.to).to be_instance_of Woyo::Location
      expect(door.to.id).to eq :away
    end

  end

  it '#here' do
    home = Woyo::Location.new :home 
    expect(home.here).to be home
  end

  it '#world' do
    world = Woyo::World.new
    home = Woyo::Location.new :home, context: world
    expect(home.world).to eq world
  end

  # it '#characters' do
  #   home = Woyo::Location.new :home do
  #     character :peter do
  #     end
  #   end
  #   home.characters.size.should eq 1
  #   peter = home.characters[:peter]
  #   peter.should be_instance_of Woyo::Character
  #   peter.location.should be home
  # end

end
