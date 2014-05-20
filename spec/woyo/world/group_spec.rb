require 'woyo/world/group'

describe Woyo::Attributes::AttributesHash do

  before :all do
    @attributes = Woyo::Attributes::AttributesHash.new
    class Listener
      attr_reader :notified, :attr, :value
      def initialize
        @notified = false
      end
      def notify attr, value
        @notified = true
        @attr = attr
        @value = value
      end
    end
    @listener = Listener.new
  end

  it 'is a kind of hash' do
    @attributes.should be_kind_of Hash
    @attributes[:test].should be nil
    @attributes[:test] = true
    @attributes[:test].should be true
  end

  it 'provides list of attribute names' do
    @attributes.names.should eq [:test]
  end

  it 'registers attribute listeners' do
    @attributes.add_attribute_listener :test, @listener
  end

  it 'maintains ilst of attribute listeners' do
    @attributes.listeners.should be_kind_of Hash
    @attributes.listeners[:test].should be @listener
  end

  it 'notifies listeners of attribute change' do
    @listener.notified.should be false
    @listener.attr.should be nil
    @listener.value.should be nil
    @attributes[:test] = :new_value
    @listener.notified.should eq true
    @listener.attr.should eq :test
    @listener.value.should eq :new_value
  end

  it 'does not notify listener if attribute does not change' do
    @attributes[:test] = :same_value
    @listener = Listener.new
    @attributes.add_attribute_listener :test, @listener
    @listener.notified.should be false
    @attributes[:test] = :same_value
    @listener.notified.should be false
  end

  it 'accepts attributes at initialization' do
    pending 'move attribute list handling into initialize'
  end

end

describe Woyo::Attributes::Group do

  before :all do
    @attributes = Woyo::Attributes::AttributesHash.new
    @group = Woyo::Attributes::Group.new @attributes, :larry, :curly, :moe
  end

  it 'requires attributes object and members symbols to initialize' do
    expect { Woyo::Attributes::Group.new @attributes, :larry, :curly, :moe }.to_not raise_error
  end

  it 'accepts attributes at initialization' do
    pending 'move attribute list handling into initialize'
  end

  it 'initializes with members backed by attributes' do
    pending 'move attribute list handling into initialize'
    @attributes.keys.should eq @group.members
  end

  it 'maintains list of members' do
    @group.members.should eq [ :larry, :curly, :moe ]
  end

  it 'member names can be listed' do
    @group.names.should eq [ :larry, :curly, :moe ]
  end

  it 'members are backed by attributes' do
    @group[:larry] = 'dumb'
    @group[:curly] = 'bald'
    @group[:moe] = 'smart'
    @group[:larry].should eq 'dumb'
    @group[:curly].should eq 'bald'
    @group[:moe].should eq 'smart'
    @attributes[:larry].should eq 'dumb'
    @attributes[:curly].should eq 'bald'
    @attributes[:moe].should eq 'smart'
  end
  
  it 'member values can be listed' do
    @group.values.should eq %w( dumb bald smart )
  end

end

describe Woyo::Attributes::BooleanGroup do

  # before :all do
  #   attributes = { tom: nil, dick: nil, harry: nil }
  #   @bg = Woyo::Attributes::BooleanGroup.new attributes, :hot, :warm, :cool, :cold
  # end

  it 'initializes with populated backing attributes'
  # it 'initializes with populated backing attributes, and members' do
  #   attributes = { tom: nil, dick: nil, harry: nil }
  #   @bg.should be_instance_of Woyo::Attributes::BooleanGroup
  # end

  it 'registers as listener for attributes'

  it 'defaults to first member true, the rest false'
  #   @bg[:hot].should be true
  #   @bg[:warm].should be false
  #   @bg[:cool].should be false
  #   @bg[:cold].should be false
  # end

  it 'setting a member true changes the rest to false'
  #   @bg[:cold] = true
  #   @bg[:hot].should be false
  #   @bg[:warm].should be false
  #   @bg[:cool].should be false
  #   @bg[:cold].should be true
  # end

  it 'setting a member false changes default to true'

  it 'can only set existing members'

end
