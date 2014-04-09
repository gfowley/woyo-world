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

  it '#here' do
    home = Woyo::Location.new :home 
    home.here.should be home
  end

  it '#ways' do
    home = Woyo::Location.new :home do
      way( :up   ) { to :roof   }
      way( :down ) { to :cellar }
      way( :out  ) { to :garden }
    end
    home.ways.count.should eq 3
    home.ways.keys.should eq [ :up, :down, :out ]
  end

end
