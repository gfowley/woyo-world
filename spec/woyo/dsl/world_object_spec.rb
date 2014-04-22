require 'woyo/dsl/world_object'

describe Woyo::WorldObject do

  context '#new' do

    it 'initializes with symbol id' do
      expect { Woyo::WorldObject.new :my_id }.to_not raise_error
    end

    it 'creates id' do
      Woyo::WorldObject.new(:my_id).id.should eq :my_id
    end

    it 'converts id to lowercase' do
      Woyo::WorldObject.new(:MY_id ).id.should eq :my_id
    end

    it 'accepts named parameter context:' do
      expect { Woyo::WorldObject.new(:my_id, context: :just_a_test ) }.to_not raise_error
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::WorldObject.new( :home ) { result = 'ok' }
      result.should eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::WorldObject.new( :home ) { self.class.should == Woyo::WorldObject }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::WorldObject.new( :home ) { |scope| result = 'ok' }
      result.should eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::WorldObject.new( :home ) { |scope| scope.should be_instance_of Woyo::WorldObject }
    end

  end

  it 'provides access to context' do
    wo = Woyo::WorldObject.new(:my_id, context: :just_a_test )
    wo.context.should eq :just_a_test
  end

end

