require 'woyo/world'

describe Woyo::World do

  it 'initializes a new world' do
    expect { Woyo::World.new }.to_not raise_error
  end
  
  it 'new world has no locations' do
    Woyo::World.new.locations.should be_empty
  end

  it 'new world has no items' do
    Woyo::World.new.items.should be_empty
  end

end
