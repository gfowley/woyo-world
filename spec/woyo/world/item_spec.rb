require 'spec_helper'
require 'woyo/world/world'
require 'woyo/world/item'

describe Woyo::Item do

  context 'in world' do

    let(:item) { Woyo::Item.new :thing, context: Woyo::World.new }

    it 'accepts world for parameter context' do
      expect(item.context).to be_instance_of Woyo::World
    end

    it '#world' do
      expect(item.world).to be_instance_of Woyo::World
    end

    it '#location' do
      expect(item.location).to be_nil
    end

  end

  context 'in a location' do

    let(:item) { Woyo::Item.new :thing, context: Woyo::Location.new(:here, context: Woyo::World.new) }

    it 'accepts location for parameter context:' do
      expect(item.context).to be_instance_of Woyo::Location
      expect(item.context.id).to eq :here
    end

    it '#location' do
      expect(item.location).to be_instance_of Woyo::Location
      expect(item.location.id).to eq :here
    end

    it '#world' do
      expect(item.world).to be_instance_of Woyo::World
    end

  end

  context 'actions' do

    let( :item ) do
      item = Woyo::Item.new :item do
        action( :action1 ) { :empty }
        action( :action2 ) { :empty }
      end
    end

    it 'are listed' do
      expect(item.actions.count).to eq 2
      expect(item.actions.keys).to eq [ :action1, :action2 ]
    end

    it 'are accessible' do
      expect(action = item.actions[:action1]).to be_instance_of Woyo::Action
      expect(action.id).to eq :action1
    end

  end

end
 
