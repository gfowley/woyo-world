require 'woyo/character'
require 'woyo/world'
require 'woyo/location'

describe Woyo::Character do

  context '#new' do

    it 'initializes with symbol id' do
      expect { Woyo::Character.new :bilbo }.to_not raise_error
    end

    it 'creates id' do
      Woyo::Character.new(:my_id).id.should eq :my_id
    end

    it 'converts id to lowercase' do
      Woyo::Character.new('MY_id').id.should eq :my_id
      Woyo::Character.new(:MY_id ).id.should eq :my_id
    end

    it 'accepts world for parameter context:' do
      expect { Woyo::Character.new(:my_id, context: Woyo::World.new) }.to_not raise_error
    end

    it 'accepts location for parameter context:' do
      expect { Woyo::Character.new(:my_id, context: Woyo::Location.new(:here)) }.to_not raise_error
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::Character.new( :bilbo ) { result = 'ok' }
      result.should eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::Character.new( :bilbo ) { self.class.should == Woyo::Character }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::Character.new( :bilbo ) { |loc| result = 'ok' }
      result.should eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::Character.new( :bilbo ) { |loc| loc.should be_instance_of Woyo::Character }
    end

  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      bilbo = Woyo::Character.new( :bilbo )
      other = bilbo.evaluate { self.should == bilbo }
      other.should be bilbo
    end

    it 'passes self to block with arity 1' do
      bilbo = Woyo::Character.new( :bilbo )
      other = bilbo.evaluate { |loc| loc.should be bilbo }
      other.should be bilbo
    end

  end

  it '#go way' do
    world = Woyo::World.new do
      location :home do
        way :out do
          to :away
        end
        character :tom
      end
      location :away do
      end
    end
    home = world.locations[:home]
    away = world.locations[:away]
    tom = home.characters[:tom]
    tom.location.should be home
    tom.go :out
    tom.location.should be away
    home.characters[:tom].should be_nil
    away.characters[:tom].should eq tom
  end

end

