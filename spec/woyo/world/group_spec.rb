require 'spec_helper'
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
    expect(@attributes).to be_kind_of Hash
    expect(@attributes[:test]).to be nil
    @attributes[:test] = true
    expect(@attributes[:test]).to be true
  end

  it 'provides list of attribute names' do
    expect(@attributes.names).to eq [:test]
  end

  it 'registers attribute listeners' do
    @attributes.add_listener :test, @listener
  end

  it 'maintains lists of attribute listeners' do
    expect(@attributes.listeners).to be_kind_of Hash
    expect(@attributes.listeners[:test]).to be_kind_of Array 
    expect(@attributes.listeners[:test].first).to be @listener
  end

  it 'notifies listeners of attribute change' do
    expect(@listener.notified).to be false
    expect(@listener.attr).to be nil
    expect(@listener.value).to be nil
    @attributes[:test] = :new_value
    expect(@listener.notified).to eq true
    expect(@listener.attr).to eq :test
    expect(@listener.value).to eq :new_value
  end

  it 'does not notify listener if attribute does not change' do
    @attributes[:test] = :same_value
    @listener = Listener.new
    @attributes.add_listener :test, @listener
    expect(@listener.notified).to be false
    @attributes[:test] = :same_value
    expect(@listener.notified).to be false
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
    expect(@group.members).to eq [ :larry, :curly, :moe ]
  end

  it 'member names can be listed' do
    expect(@group.names).to eq [ :larry, :curly, :moe ]
  end

  it 'members are backed by attributes' do
    @group[:larry] = 'dumb'
    @group[:curly] = 'bald'
    @group[:moe] = 'smart'
    expect(@group[:larry]).to eq 'dumb'
    expect(@group[:curly]).to eq 'bald'
    expect(@group[:moe]).to eq 'smart'
    expect(@attributes[:larry]).to eq 'dumb'
    expect(@attributes[:curly]).to eq 'bald'
    expect(@attributes[:moe]).to eq 'smart'
  end
  
  it 'member values can be listed' do
    expect(@group.values).to eq %w( dumb bald smart )
  end

end

describe Woyo::Attributes::Exclusion do

  before :all do
    @group = Woyo::Attributes::Exclusion.new Woyo::Attributes::AttributesHash.new, :warm, :cool, :cold
  end

  it 'has default' do
    expect(@group.default).to eq :warm
  end

  it 'defaults to first member true, the rest false' do
    expect(@group[:warm]).to be true
    expect(@group[:cool]).to be false
    expect(@group[:cold]).to be false
  end
  
  it 'registers as listener for attributes' do
    @group.members.each do |member|
      expect(@group.attributes.listeners[member].first).to be @group
    end
  end

  it 'setting a member true changes the rest to false' do
    @group[:cold] = true
    expect(@group[:warm]).to be false
    expect(@group[:cool]).to be false
    expect(@group[:cold]).to be true
  end

  it 'for a group > 2 members setting a true member false reverts to default' do
    @group[:cold] = false
    expect(@group[:warm]).to be true
    expect(@group[:cool]).to be false
    expect(@group[:cold]).to be false
  end

  it 'for a binary group setting a true member false sets the other true' do
    @binary_group = Woyo::Attributes::Exclusion.new Woyo::Attributes::AttributesHash.new, :yes, :no
    expect(@binary_group[:yes]).to be true
    expect(@binary_group[:no]).to be false
    @binary_group[:yes] = false
    expect(@binary_group[:yes]).to be false
    expect(@binary_group[:no]).to be true
  end

  it 'can only set existing members' do
    expect { @group[:bogus] = true }.to raise_error
  end

  it 'can be reset to default!' do
    @group[:cool] = true 
    @group.default!
    expect(@group[:warm]).to eq true
  end

  it '#value returns name of true member' do
    @group[:warm] = true
    expect(@group.value).to eq :warm
    @group[:cold] = true
    expect(@group.value).to eq :cold
  end

end
