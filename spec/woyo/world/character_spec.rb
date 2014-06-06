require 'woyo/world/character'
require 'woyo/world/world'
require 'woyo/world/location'

describe Woyo::Character do

  let(:char) { Woyo::Character.new :boss }

  it 'has attributes' do
    expect(char.attributes).to be_instance_of Woyo::Attributes::AttributesHash
    expect(char.attributes.names.sort).to eq [:description,:name]
  end

  it 'name attribute defaults to id' do
    expect(char.name).to eq 'Boss'
  end

  it 'accepts world for parameter context:' do
    wo = nil
    expect { wo = Woyo::Character.new(:my_id, context: Woyo::World.new) }.to_not raise_error
    expect(wo.context).to be_instance_of Woyo::World
  end

  it 'accepts location for parameter context:' do
    wo = nil
    expect { wo = Woyo::Character.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
    expect(wo.context).to be_instance_of Woyo::Location
    expect(wo.context.id).to eq :here
  end

  # it 'can go way' do
  #   world = Woyo::World.new do
  #     location :home do
  #       way :out do
  #         to :away
  #       end
  #       character :tom
  #     end
  #     location :away do
  #     end
  #   end
  #   home = world.locations[:home]
  #   away = world.locations[:away]
  #   tom = home.characters[:tom]
  #   tom.location.should be home
  #   tom.go :out
  #   tom.location.should be away
  #   home.characters[:tom].should be_nil
  #   away.characters[:tom].should eq tom
  # end

end

