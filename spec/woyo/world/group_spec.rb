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

  it 'maintains list of attribute listeners' do
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

end

describe Woyo::Attributes::Group do

  before :all do
    @attributes = Woyo::Attributes::AttributesHash.new
    @group = Woyo::Attributes::Group.new @attributes, :larry, :curly, :moe
  end

  it '#initialize requires attributes object' do
    expect { Woyo::Attributes::Group.new @attributes, :larry, :curly, :moe }.to_not raise_error
    expect { Woyo::Attributes::Group.new }.to raise_error
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

describe Woyo::Attributes::Exclusion do

  before :all do
    @group = Woyo::Attributes::Exclusion.new Woyo::Attributes::AttributesHash.new, :warm, :cool, :cold
  end

  it 'has default' do
    @group.default.should eq :warm
  end

  it 'defaults to first member true, the rest false' do
    @group[:warm].should be true
    @group[:cool].should be false
    @group[:cold].should be false
  end
  
  it 'registers as listener for attributes' do
    @group.members.each do |member|
      @group.attributes.listeners[member].should be @group
    end
  end

  it 'setting a member true changes the rest to false' do
    @group[:cold] = true
    @group[:warm].should be false
    @group[:cool].should be false
    @group[:cold].should be true
  end

  it 'for a group > 2 members setting a true member false reverts to default' do
    @group[:cold] = false
    @group[:warm].should be true
    @group[:cool].should be false
    @group[:cold].should be false
  end

  it 'for a binary group setting a true member false sets the other true' do
    @binary_group = Woyo::Attributes::Exclusion.new Woyo::Attributes::AttributesHash.new, :yes, :no
    @binary_group[:yes].should be true
    @binary_group[:no].should be false
    @binary_group[:yes] = false
    @binary_group[:yes].should be false
    @binary_group[:no].should be true
  end

  it 'can only set existing members' do
    expect { @group[:bogus] = true }.to raise_error
  end

  it 'can be reset to default!' do
    @group[:cool] = true 
    @group.default!
    @group[:warm].should eq true
  end

  it '#value returns name of true member' do
    @group[:warm] = true
    @group.value.should eq :warm
    @group[:cold] = true
    @group.value.should eq :cold
  end

end
