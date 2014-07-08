require 'spec_helper'
require 'woyo/world/world_object'

describe Woyo::WorldObject do

  context '#new' do

    it 'initializes with symbol id' do
      expect { Woyo::WorldObject.new :my_id }.to_not raise_error
    end

    it 'creates id' do
      expect(Woyo::WorldObject.new(:my_id).id).to eq :my_id
    end

    it 'converts id to lowercase' do
      expect(Woyo::WorldObject.new(:MY_id ).id).to eq :my_id
    end

    it 'accepts named parameter context:' do
      expect { Woyo::WorldObject.new(:my_id, context: :just_a_test ) }.to_not raise_error
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::WorldObject.new( :home ) { result = 'ok' }
      expect(result).to eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::WorldObject.new( :home ) { self.class.should == Woyo::WorldObject }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::WorldObject.new( :home ) { |scope| result = 'ok' }
      expect(result).to eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::WorldObject.new( :home ) { |scope| expect(scope).to be_instance_of Woyo::WorldObject }
    end

  end

  it 'provides access to context' do
    wo = Woyo::WorldObject.new(:my_id, context: :just_a_test )
    expect(wo.context).to eq :just_a_test
  end

  context 'has' do

    it 'attributes' do
      wo = Woyo::WorldObject.new :thing do
        attribute color: :red
      end
      expect(wo.color).to eq :red
      wo.color = :blue
      expect(wo.color).to eq :blue
    end

    it 'actions' do
      wo = Woyo::WorldObject.new :thing do
        action :time do
          Time.now
        end
      end
      expect(wo.time).to be < Time.now
    end

  end

end

