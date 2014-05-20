require 'woyo/world/group'

describe Woyo::Attributes::AttributesHash do

  it 'is a kind of hash'

  it 'registers attribute listeners'

  it 'maintains list of listeners'

  it 'notifies listeners of attribute change'

  it 'does not notofy listener if attribute does not change'

end

describe Woyo::Attributes::Group do

  it 'requires attributes object and members symbols to initialize'

  it 'initializes with populated backing attributes'

  it 'members backed by attributes'

  it 'member names can be listed'

  it 'member values can be listed'

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
