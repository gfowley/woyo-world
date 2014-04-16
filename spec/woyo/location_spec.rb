require 'woyo/world'
require 'woyo/location'
require 'woyo/way'

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

    it 'accepts named parameter world:' do
      expect { Woyo::Location.new(:my_id, context: Woyo::World.new) }.to_not raise_error
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
      home = Woyo::Location.new( :home )
      other = home.evaluate { self.should == home }
      other.should be home
    end

    it 'passes self to block with arity 1' do
      home = Woyo::Location.new( :home )
      other = home.evaluate { |loc| loc.should be home }
      other.should be home
    end

  end

  context 'attributes' do

    it 'names can be listed for class' do
      attrs = Woyo::Location.attributes
      attrs.should be_instance_of Array
      attrs.all? { |a| a.is_a? Symbol }.should be_true
    end                       

    it 'names and values can be listed for instance' do
      home = Woyo::Location.new :home
      home.attributes.should be_instance_of Hash
    end

    it 'can be written with =' do
      home = Woyo::Location.new :home
      Woyo::Location.attributes.each do |attr|
        eval "home.#{attr} = '#{attr}'.upcase"
      end
      home.attributes.count.should eq Woyo::Location.attributes.count
      home.attributes.each do |name,value|
        value.should eq name.to_s.upcase
      end
    end

    it 'can be written without =' do
      home = Woyo::Location.new :home
      Woyo::Location.attributes.each do |attr|
        eval "home.#{attr} '#{attr}'.upcase"
      end
      home.attributes.count.should eq Woyo::Location.attributes.count
      home.attributes.each do |name,value|
        value.should eq name.to_s.upcase
      end
    end

    it 'can be read' do
      home = Woyo::Location.new :home
      Woyo::Location.attributes.each do |attr|
        eval "home.#{attr} '#{attr}'.upcase"
      end
      home.attributes.count.should eq Woyo::Location.attributes.count
      home.attributes.each do |name,value|
        eval("home.#{name}").should eq value
      end
    end

  end

  context 'ways' do

    it 'are listed (#ways)' do
      home = Woyo::Location.new :home do
        way( :up   ) { to :roof   }
        way( :down ) { to :cellar }
        way( :out  ) { to :garden }
      end
      home.ways.count.should eq 3
      home.ways.keys.should eq [ :up, :down, :out ]
    end

    it 'are from here' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      door.from.should eq home
    end

    it 'go to locations' do
      home = Woyo::Location.new :home do
        way :door do
          to :away
        end
      end
      door = home.ways[:door]
      door.to.should be_instance_of Woyo::Location
      door.to.id.should eq :away
    end

  end

  it '#here' do
    home = Woyo::Location.new :home 
    home.here.should be home
  end

  it '#world' do
    world = Woyo::World.new
    home = Woyo::Location.new :home, context: world
    home.world.should eq world
  end

  it '#characters' do
    home = Woyo::Location.new :home do
      character :peter do
      end
    end
    home.characters.size.should eq 1
    peter = home.characters[:peter]
    peter.should be_instance_of Woyo::Character
    peter.location.should be home
  end

end
