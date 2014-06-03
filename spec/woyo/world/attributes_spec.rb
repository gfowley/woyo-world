require 'woyo/world/attributes'

describe Woyo::Attributes do

  before :all do
    class AttrTest
      include Woyo::Attributes
    end
  end
  
  it '#attributes returns empty AttributesHash for instance with no attributes' do
    attr_test = AttrTest.new
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    attr_test.attributes.count.should eq 0
  end

  it '#attributes returns AttributesHash with names and nil values for instance with unpopulated attributes' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    attr_test.attributes.keys.should eq [ :attr1, :attr2, :attr3 ]  
    attr_test.attributes.values.should eq [ nil, nil, nil ]
  end

  it '#attributes returns AttributeHash with names and values for instance with populated attributes' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    attr_test.attributes.keys.should eq [ :attr1, :attr2, :attr3 ]
    attr_test.attributes.keys.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.values.should eq [ 'ATTR1', 'ATTR2', 'ATTR3' ]
  end

  it '#attributes returns AttributesHash with names and default values for instance with unpopulated attributes' do
    attr_test = AttrTest.new
    attr_test.attributes one: 1, two: 2, three: proc { 3 } 
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    attr_test.attributes.keys.should eq [ :one, :two, :three ]  
    attr_test.attributes.values.should eq [ 1, 2, 3 ]
  end

  it 'have convenience accessor :names for :keys' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.names.should eq [ :attr1, :attr2, :attr3 ]  
  end

  it 'can be written via method with =' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.names.each do |attr|
      attr_test.send("#{attr}=", attr.to_s.upcase)
    end
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be written via method without =' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.names.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be read via method' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes.names.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.each do |name,value|
      eval("attr_test.#{name}").should eq value
    end
  end

  it 'list can be added to' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes :attr4, :attr5, :attr6
    attr_test.attributes.count.should eq 6
    attr_test.attributes.names.should eq [ :attr1, :attr2, :attr3, :attr4, :attr5, :attr6 ]
  end

  it 'list can be added to without duplication' do
    attr_test = AttrTest.new
    attr_test.attributes :attr1, :attr2, :attr3
    attr_test.attributes :attr2, :attr3, :attr4
    attr_test.attributes.count.should eq 4
    attr_test.attributes.names.should eq [ :attr1, :attr2, :attr3, :attr4 ]
  end

  it 'can be defined with "attribute"' do
    attr_test = AttrTest.new
    attr_test.attribute :open
    attr_test.open.should be_nil
    attr_test.open = true
    attr_test.open.should be_true
  end
      
  it 'can have a default value' do
    attr_test = AttrTest.new
    attr_test.attributes attr_with_array___default: [ 1, 2, 3 ]
    attr_test.attributes attr_with_hash____default: { a: 1, b: 2, c: 3 }
    attr_test.attributes attr_with_number__default: 12345
    attr_test.attributes attr_with_string__default: "abcde"
    attr_test.attributes attr_with_boolean_default: true
    attr_test.attr_with_array___default.should eq [ 1, 2, 3 ]
    attr_test.attr_with_hash____default.should eq ( { a: 1, b: 2, c: 3 } )
    attr_test.attr_with_number__default.should eq 12345
    attr_test.attr_with_string__default.should eq "abcde"
    attr_test.attr_with_boolean_default.should eq true
  end

  it 'can have a default proc' do
    attr_test = AttrTest.new
    attr_test.attributes attr_with_proc_default: proc { Time.now }
    attr_test.attr_with_proc_default.should be < Time.now
  end

  it 'default proc runs in instance scope' do
    attr_test = AttrTest.new
    attr_test.define_singleton_method(:my_method) { "okay" }
    attr_test.attributes attr_with_proc_default: proc { |this| this.my_method }
    attr_test.attr_with_proc_default.should eq "okay"
  end

  it 'can have a default lambda' do
    attr_test = AttrTest.new
    attr_test.attributes attr_with_lambda_default: lambda { Time.now }
    attr_test.attr_with_lambda_default.should be < Time.now
  end

  it 'default lambda runs in instance scope' do
    attr_test = AttrTest.new
    attr_test.define_singleton_method(:my_method) { "okay" }
    attr_test.attributes attr_with_lambda_default: lambda { |this| this.my_method }
    attr_test.attr_with_lambda_default.should eq "okay"
  end

  context 'that are boolean have convenient instance accessors' do

    let(:bat) { class BooleanAttrTest; include Woyo::Attributes; end.new }

    before :each do
      bat.attribute open: true
    end

    it '#attr?' do
      bat.open.should eq true
      bat.open?.should eq true
    end

    it '#attr!' do
      bat.open = false
      bat.open.should eq false
      bat.open!.should eq true
      bat.open.should eq true
    end

    it '#is? :attr' do
      bat.is?(:open).should eq true
      bat.open = false
      bat.is?(:open).should eq false
    end

    it '#is :attr' do
      bat.open = false
      bat.open.should eq false
      bat.is(:open)
      bat.open.should eq true
    end

  end

  context 'can be re-defined' do

    let(:ard) { AttrTest.new }

    it 'without duplication' do
      ard.attribute :attr
      ard.attribute :attr
      ard.attributes.count.should eq 1
      ard.attributes.names.should eq [:attr] 
      ard.attr.should eq nil 
    end

    it 'to set default' do
      ard.attribute :attr
      ard.attribute :attr => 'default'
      ard.attributes.count.should eq 1
      ard.attributes.names.should eq [:attr] 
      ard.attr.should eq 'default' 
    end

    it 'to change default'  do
      ard.attribute :attr => 'old_default'
      ard.attribute :attr => 'new_default'
      ard.attributes.count.should eq 1
      ard.attributes.names.should eq [:attr] 
      ard.attr.should eq 'new_default' 
    end

  end

  context 'groups' do

    let(:gat) { AttrTest.new }

    before :each do
      gat.group :stooges, :larry, :curly, :moe
    end

    it 'can be accessed by named instance methods' do
      gat.stooges.should be_instance_of Woyo::Attributes::Group
    end

    it 'names and nil values can be retrieved' do
      gat.stooges.should be_instance_of Woyo::Attributes::Group
      gat.stooges.count.should eq 3
      gat.stooges.names.should eq [ :larry, :curly, :moe ] 
      gat.stooges.values.should eq [ nil, nil, nil ] 
    end

    it 'names and default values can be retrieved' do
      gat.group :numbers, one: 1, two: 2, three: proc { 3 } 
      gat.numbers.should be_instance_of Woyo::Attributes::Group
      gat.numbers.count.should eq 3
      gat.numbers.names.should eq [ :one, :two, :three ]  
      gat.numbers.values.should eq [ 1, 2, 3 ]
    end

    it 'members can be accessed via group' do
      gat.stooges[:curly].should eq nil
      gat.stooges[:curly] = 'bald'
      gat.stooges[:curly].should eq 'bald'
    end

    it 'members are attributes' do
      gat.attributes.keys.should eq [ :larry, :curly, :moe ]  
      gat.stooges[:larry] = 'knucklehead'
      gat.larry.should eq 'knucklehead' 
    end

    it 'attributes are members' do
      gat.moe = 'smart'
      gat.stooges[:moe].should eq 'smart'
    end

    it '#groups returns hash with names and groups' do
      gat.group :numbers, one: 1, two: 2, three: proc { 3 } 
      gat.groups.should eq( { stooges: gat.stooges, numbers: gat.numbers } )
    end

  end

  context 'exclusions' do

    let(:xat) { AttrTest.new }

    before :each do
      xat.exclusion :temp, :warm, :cool, :cold
    end

    it 'can be accessed by named instance methods' do
      xat.temp.should be_instance_of Woyo::Attributes::Exclusion
    end

    it 'first member is true, rest are false' do
      xat.temp[:warm].should eq true
      xat.temp[:cool].should eq false
      xat.temp[:cold].should eq false
    end

    it 'making group member true affects member attributes' do
      xat.temp[:cold] = true
      xat.cold.should be true
      xat.cool.should be false
      xat.warm.should be false
    end

    it 'making attribute true affects group members' do
      xat.cool = true
      xat.temp[:cold].should be false
      xat.temp[:cool].should be true
      xat.temp[:warm].should be false
    end

    it '#exclusions returns hash with names and exlcusions' do
      xat.exclusion :light, :dark, :dim, :bright
      xat.exclusions.should eq( { temp: xat.temp, light: xat.light } )
    end

  end

  context 'with Hash value' do

    let(:hat) { AttrTest.new }

    before :each do
      hat.attributes :reaction, :hot, :cold
    end

    it 'accept a hash as value' do
      expect { hat.reaction hot: 'Sweat', cold: 'Shiver' }.to_not raise_error
    end

    it 'return the value of the first key that evaluates as a true attribute' do
      hat.reaction hot: 'Sweat', cold: 'Shiver' 
      hat.cold = true
      hat.reaction.should eq 'Shiver'
      hat.hot = true
      hat.reaction.should eq 'Sweat'
    end

    it 'otherwise return the hash' do
      hat.reaction hot: 'Sweat', cold: 'Shiver' 
      hat.cold = false
      hat.hot = false
      hat.reaction.should eq ( { :hot => 'Sweat', :cold => 'Shiver' } )
    end

  end

end

