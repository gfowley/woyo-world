require 'woyo/world/world'

describe Woyo::World do

  it 'has attributes :name, :description, :start' do
    expected_attrs = [:name,:description,:start]
    Woyo::World.attributes.sort.should eq expected_attrs.sort 
  end

  it 'name attribute defaults to id'

  it 'initializes with no locations' do
    Woyo::World.new.locations.should be_empty
  end

  it 'initializes with no characters' do
    Woyo::World.new.characters.should be_empty
  end

end
