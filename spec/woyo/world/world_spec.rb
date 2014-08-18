require 'spec_helper'
require 'woyo/world/world'

describe Woyo::World do

  let(:world) { Woyo::World.new }

  it 'has attribute :start' do
    expect(world.attributes).to be_instance_of Woyo::Attributes::AttributesHash
    expect(world.attributes.names).to include :start
  end

  it 'has locations' do
    expect(world.locations).to be_empty
  end

  it 'has characters' do
    expect(world.characters).to be_empty
  end

  it 'has items' do
    expect(world.items).to be_empty
  end

  it 'can track all attribute changes'

end

