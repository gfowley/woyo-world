require 'woyo/world/attributes'

describe Woyo::Attributes do

  before :all do
    class AttrTest
      include Woyo::Attributes
      attributes :attr1, :attr2, :attr3
    end
  end
  
  it 'names can be listed for class' do
    attrs = AttrTest.attributes
    attrs.should be_instance_of Array
    attrs.count.should eq 3
    attrs.all? { |a| a.is_a? Symbol }.should be_true
  end                       

  it 'hash of names and values can be retrieved for instance' do
    attr_test = AttrTest.new
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    # set attributes
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.keys.should eq [ :attr1, :attr2, :attr3 ]
    attr_test.attributes.values.should eq [ 'ATTR1', 'ATTR2', 'ATTR3' ]
  end

  it 'hash of names and nil values can be retrieved for instance before populating' do
    attr_test = AttrTest.new
    attr_test.attributes.should be_instance_of Woyo::Attributes::AttributesHash
    attr_test.attributes.keys.should eq [ :attr1, :attr2, :attr3 ]  
    attr_test.attributes.values.should eq [ nil, nil, nil ]
  end

  it 'hash of names and default values can be retrieved for instance before populating' do
    expect { 
      class DefTest
        include Woyo::Attributes
        attributes one: 1, two: 2, three: proc { 3 } 
      end
    }.to_not raise_error
    def_test = DefTest.new
    def_test.attributes.keys.should eq [ :one, :two, :three ]  
    def_test.attributes.values.should eq [ 1, 2, 3 ]
  end

  it 'have convenience accessor :names for :keys' do
    attr_test = AttrTest.new
    attr_test.attributes.names.should eq [ :attr1, :attr2, :attr3 ]  
  end

  it 'can be written via method with =' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      attr_test.send("#{attr}=", attr.to_s.upcase)
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be written via method without =' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      value.should eq name.to_s.upcase
    end
  end

  it 'can be read via method' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.count.should eq AttrTest.attributes.count
    attr_test.attributes.each do |name,value|
      eval("attr_test.#{name}").should eq value
    end
  end

  it 'list can be added to' do
    expect {
      class AttrTest
        attributes :attr4, :attr5, :attr6
      end
    }.to_not raise_error
    AttrTest.attributes.count.should eq 6
    attr_test = AttrTest.new
    # populate attributes
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.count.should eq 6
  end

  it 'can be defined with "attribute"' do
    expect {
      class AttrTest
        attribute :open
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.open.should be_nil
    attr_test.open = true
    attr_test.open.should be_true
  end
      
  it 'can have a default value' do
    expect { 
      class AttrTest
        attributes attr_with_array___default: [ 1, 2, 3 ]
        attributes attr_with_hash____default: { a: 1, b: 2, c: 3 }
        attributes attr_with_number__default: 12345
        attributes attr_with_string__default: "abcde"
        attributes attr_with_boolean_default: true
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.attr_with_array___default.should eq [ 1, 2, 3 ]
    attr_test.attr_with_array___default = :array
    attr_test.attr_with_array___default.should eq :array
    attr_test.attr_with_hash____default.should eq ( { a: 1, b: 2, c: 3 } )
    attr_test.attr_with_hash____default = :hash
    attr_test.attr_with_hash____default.should eq :hash
    attr_test.attr_with_number__default.should eq 12345
    attr_test.attr_with_number__default = :number
    attr_test.attr_with_number__default.should eq :number
    attr_test.attr_with_string__default.should eq "abcde"
    attr_test.attr_with_string__default = :string
    attr_test.attr_with_string__default.should eq :string
    attr_test.attr_with_boolean_default.should eq true
    attr_test.attr_with_boolean_default = :boolean
    attr_test.attr_with_boolean_default.should eq :boolean
  end

  it 'can have a default proc' do
    expect {
      class AttrTest
        attributes attr_with_proc_default: proc { Time.now }
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.attr_with_proc_default.should be < Time.now
  end

  it 'default proc runs in instance scope' do
    expect {
      class AttrTest
        attributes attr_with_proc_default: proc { |this| this.my_method }
        def my_method
          "okay"
        end
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.attr_with_proc_default.should eq "okay"
  end

  it 'can have a default lambda' do
    expect {
      class AttrTest
        attributes attr_with_lambda_default: lambda { Time.now }
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.attr_with_lambda_default.should be < Time.now
  end

  it 'default lambda runs in instance scope' do
    expect {
      class AttrTest
        attributes attr_with_lambda_default: lambda { |this| this.my_method }
        def my_method
          "okay"
        end
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.attr_with_lambda_default.should eq "okay"
  end

  it 'detected as boolean have convenience accessors' do
    expect {
      class AttrTest
        attribute open: true
        attribute light: false 
      end
    }.to_not raise_error
    attr_test = AttrTest.new
    attr_test.open.should eq true
    attr_test.open?.should eq true
    attr_test.is?(:open).should eq true
    attr_test.open = false
    attr_test.open.should eq false
    attr_test.open!.should eq true
    attr_test.open.should eq true
    attr_test.light.should eq false
    attr_test.light?.should eq false
    attr_test.is?(:light).should eq false
    attr_test.light!.should eq true
    attr_test.light.should eq true
  end

  context 'groups' do

    before :all do
      class AT
        include Woyo::Attributes
        group :stooges, :larry, :curly, :moe
        group :cars,    :mustang, :ferarri, :mini 
      end
      @at = AT.new
    end

    it 'can be listed for class' do
      groups = AT.groups
      groups.should be_instance_of Hash
      groups.count.should eq 2
      groups.keys.should eq [ :stooges, :cars ]
      groups[:stooges].should eq [ :larry, :curly, :moe ]
      groups[:cars].should eq [ :mustang, :ferarri, :mini ]
    end

    it 'have convenience accessor :names for :keys' do
      @at.stooges.names.should eq [ :larry, :curly, :moe ]  
    end

    it 'names and nil values can be retrieved from instance without populating' do
      @at.stooges.should be_instance_of Woyo::Attributes::Group
      @at.stooges.count.should eq 3
      @at.stooges.names.should eq [ :larry, :curly, :moe ] 
      @at.stooges.values.should eq [ nil, nil, nil ] 
    end

    it 'names and default values can be retrieved from instance without populating' do
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
      @at.stooges[:curly].should eq nil
      @at.stooges[:curly] = 'bald'
      @at.stooges[:curly].should eq 'bald'
    end

    it 'members are also attributes' do
      all_attrs = [ :larry, :curly, :moe, :mustang, :ferarri, :mini ]  
      @at.attributes.keys.should eq all_attrs 
      all_attrs.each do |attr|
        @at.should respond_to attr
      end
    end

    it 'members are attributes' do
      @at.stooges[:moe] = 'knucklehead'
      @at.stooges[:moe].should eq 'knucklehead'
      @at.moe.should eq 'knucklehead' 
    end

    it 'attributes are members' do
      @at.ferarri = 'fast'
      @at.ferarri.should eq 'fast'
      @at.cars[:ferarri].should eq 'fast'
    end

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

    it 'are accessible via methods for instance' do
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

