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
    attr_test.attributes.should be_instance_of Hash
    # populate attributes (todo: fix this, i think this is empty until values are actually assigned...)
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.keys.should eq [ :attr1, :attr2, :attr3 ]  
  end

  it 'have convenience accessor :names for :keys' do
    attr_test = AttrTest.new
    # populate attributes (todo: fix)
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
    end
    attr_test.attributes.names.should eq [ :attr1, :attr2, :attr3 ]  
  end

  it 'can be written via method with =' do
    attr_test = AttrTest.new
    AttrTest.attributes.each do |attr|
      attr_test.send(attr, attr.to_s.upcase)
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

    it 'are a Hash' do
      @at.stooges.should be_instance_of Hash
      @at.stooges.count.should eq 3
      @at.stooges.keys.should eq [ :larry, :curly, :moe ] 
    end

    it 'members are just attributes' do
      all_attrs = [ :larry, :curly, :moe, :mustang, :ferarri, :mini ]  
      @at.attributes.keys.should eq all_attrs 
      all_attrs.each do |attr|
        @at.should respond_to attr
      end
    end

    it 'have convenience accessor :names for :keys' do
      @at.stooges.names.should eq [ :larry, :curly, :moe ]  
    end

  end

end

