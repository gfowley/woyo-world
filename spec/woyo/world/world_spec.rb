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

  it 'has no context' do
    expect(world.context).to be_nil
  end

  it 'has optional id' do
    expect(world.id).to be_nil
    my_world = Woyo::World.new :my_id
    expect(my_world.id).to eq :my_id
  end

end

