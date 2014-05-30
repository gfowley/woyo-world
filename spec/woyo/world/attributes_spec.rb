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

    before :all do
      gat.group :stooges, :larry, :curly, :moe
      #gat.group :cars,    :mustang, :ferarri, :mini 
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
      expect { 
        class GroupDefTest
          include Woyo::Attributes
          group :numbers, one: 1, two: 2, three: proc { 3 } 
        end
      }.to_not raise_error
      def_test = GroupDefTest.new
      groups = def_test.groups
      groups.should be_instance_of Hash
      groups.count.should eq 1
      groups.names.should eq [ :numbers ]
      groups[:numbers].should be_instance_of Woyo::Attributes::Group
      groups[:numbers].names.should eq [ :one, :two, :three ]
      groups[:numbers].values.should eq [ 1, 2, 3 ]
      def_test.numbers.names.should eq [ :one, :two, :three ]  
      def_test.numbers.values.should eq [ 1, 2, 3 ]
    end

    it 'members can be accessed via group' do
      gat.stooges[:curly].should eq nil
      gat.stooges[:curly] = 'bald'
      gat.stooges[:curly].should eq 'bald'
    end

    it 'members are also attributes' do
      all_attrs = [ :larry, :curly, :moe, :mustang, :ferarri, :mini ]  
      gat.attributes.keys.should eq all_attrs 
      all_attrs.each do |attr|
        gat.should respond_to attr
      end
    end

    it 'members are attributes' do
      gat.stooges[:moe] = 'knucklehead'
      gat.stooges[:moe].should eq 'knucklehead'
      gat.moe.should eq 'knucklehead' 
    end

    it 'attributes are members' do
      gat.ferarri = 'fast'
      gat.ferarri.should eq 'fast'
      gat.cars[:ferarri].should eq 'fast'
    end

    #it '#groups returns list or groups or something...'

  end

  context 'boolean groups' do

    before :all do
      class ExGroupTest
        include Woyo::Attributes
        group! :temp, :hot, :warm, :cool, :cold
        group! :light, :dark, :dim, :bright
      end
    end

    it 'are listed for a class' do
      groups = ExGroupTest.boolean_groups
      groups.should be_instance_of Hash
      groups.count.should eq 2
      groups.keys.should eq [ :temp, :light ]
      groups[:temp].should eq [ :hot, :warm, :cool, :cold ] 
      groups[:light].should eq [ :dark, :dim, :bright ]
    end

    it 'accessor returns BooleanGroup instance' do
      egt = ExGroupTest.new
      egt.temp.should be_instance_of Woyo::Attributes::BooleanGroup
    end

    it 'first member is true, rest are false' do
      egt = ExGroupTest.new
      egt.light[:dark].should eq true
      egt.light[:dim].should eq false
      egt.light[:bright].should eq false
    end

    it 'making group member true affects member attributes' do
      egt = ExGroupTest.new
      egt.temp[:cold] = true
      egt.cold.should be true
      egt.cool.should be false
      egt.warm.should be false
      egt.hot.should be false
    end

    it 'making attribute true affects group members' do
      egt = ExGroupTest.new
      egt.cold = true
      egt.light[:cold].should be true
      egt.light[:cool].should be false
      egt.light[:warm].should be false
      egt.light[:hot].should be false
    end

  end

  context 'assigned a Hash as a value' do

    before :all do
      class AttrHashTest
        include Woyo::Attributes
        attributes :reaction, :hot, :cold
      end
      @aht = AttrHashTest.new
    end

    it 'accepts the hash as a value' do
      expect { @aht.reaction hot: 'Sweat', cold: 'Shiver' }.to_not raise_error
    end

    it 'returns the value of the first key that evaluates as a true attribute' do
      @aht.cold = true
      @aht.reaction.should eq 'Shiver'
      @aht.hot = true
      @aht.reaction.should eq 'Sweat'
    end

    it 'otherwise it returns the hash' do
      reactions = { :hot => 'Sweat', :cold => 'Shiver' }
      @aht.cold = false
      @aht.hot = false
      @aht.reaction.should eq reactions
    end

  end

end

