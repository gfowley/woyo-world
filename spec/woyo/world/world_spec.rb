require 'woyo/world/world'

describe Woyo::World do

  let(:world) { Woyo::World.new }

  it 'has attributes :name, :description, :start' do
    world.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    world.attributes.names.sort.should eq [:description,:name,:start]
  end

  it 'initializes with no locations' do
    world.locations.should be_empty
  end

  it 'initializes with no characters' do
    world.characters.should be_empty
  end

end

