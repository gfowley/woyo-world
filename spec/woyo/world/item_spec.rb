require 'spec_helper'
require 'woyo/world/world'
require 'woyo/world/item'

describe Woyo::Item do

  context 'itself' do

    let(:item) { Woyo::Item.new :thing }

    it 'has default attributes' do
      expect(item.attributes).to be_instance_of Woyo::Attributes::AttributesHash
      expect(item.attributes.names.sort).to eq [:description,:name]
    end

    it 'name attribute defaults to id' do
      expect(item.name).to eq 'Thing'
    end

  end

  context 'in a location' do

    let(:item) { Woyo::Item.new :thing, context: Woyo::Location.new(:here) }

    it 'accepts location for parameter context:' do
      expect(item.context).to be_instance_of Woyo::Location
      expect(item.context.id).to eq :here
    end

    it '#location' do
      expect(item.location).to be_instance_of Woyo::Location
      expect(item.location.id).to eq :here
    end

  end

  context 'attributes' do

    let(:item) do
      Woyo::Item.new :thing do
        attribute color: :red
      end
    end

    it 'are accessible' do
      expect(item.color).to eq :red
      item.color = :blue
      expect(item.color).to eq :blue
    end

  end

  it 'connect ?'

end
 
