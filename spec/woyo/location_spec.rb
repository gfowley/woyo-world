require 'woyo/location'

describe Woyo::Location do

  context '#new' do

    it 'initializes with string id' do
      expect { Woyo::Location.new 'my_id' }.to_not raise_error
    end

    it 'initializes with symbol id' do
      expect { Woyo::Location.new :my_id }.to_not raise_error
    end

    it 'creates id' do
      Woyo::Location.new(:my_id).id.should eq :my_id
    end

    it 'converts string id to symbol' do
      Woyo::Location.new('my_id').id.should eq :my_id
    end

    it 'converts id to lowercase' do
      Woyo::Location.new('MY_id').id.should eq :my_id
      Woyo::Location.new(:MY_id ).id.should eq :my_id
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::Location.new( :home ) { result = 'ok' }
      result.should eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::Location.new( :home ) { self.class.should == Woyo::Location }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::Location.new( :home ) { |loc| result = 'ok' }
      result.should eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::Location.new( :home ) { |loc| loc.should be_instance_of Woyo::Location }
    end

  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      Woyo::Location.new( :home ).evaluate { self.class.should == Woyo::Location }
    end

    it 'passes self to block with arity 1' do
      Woyo::Location.new( :home ).evaluate { |loc| loc.should be_instance_of Woyo::Location }
    end

  end
end
