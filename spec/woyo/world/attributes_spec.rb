require 'spec_helper'
require 'woyo/world/attributes'

describe Woyo::Attributes do

  before :all do
    class AttrTest
      include Woyo::Attributes
    end
  end

  context '#attributes' do

    it 'returns empty AttributesHash for instance with no attributes' do
      attr_test = AttrTest.new
      expect(attr_test.attributes).to be_instance_of Woyo::Attributes::AttributesHash
      expect(attr_test.attributes.count).to eq 0
    end

    it 'returns AttributesHash with names and nil values for instance with unpopulated attributes' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      expect(attr_test.attributes).to be_instance_of Woyo::Attributes::AttributesHash
      expect(attr_test.attributes.keys).to eq [ :attr1, :attr2, :attr3 ]  
      expect(attr_test.attributes.values).to eq [ nil, nil, nil ]
    end

    it 'returns AttributesHash with names and values for instance with populated attributes' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      expect(attr_test.attributes).to be_instance_of Woyo::Attributes::AttributesHash
      expect(attr_test.attributes.keys).to eq [ :attr1, :attr2, :attr3 ]
      attr_test.attributes.keys.each do |attr|
        attr_test.send(attr, attr.to_s.upcase)
      end
      expect(attr_test.attributes.values).to eq [ 'ATTR1', 'ATTR2', 'ATTR3' ]
    end

    it 'returns AttributesHash with names and default values for instance with unpopulated attributes' do
      attr_test = AttrTest.new
      attr_test.attributes one: 1, two: 2, three: 3 
      expect(attr_test.attributes).to be_instance_of Woyo::Attributes::AttributesHash
      expect(attr_test.attributes.keys).to eq [ :one, :two, :three ]  
      expect(attr_test.attributes.values).to eq [ 1, 2, 3 ]
    end

    it 'provides convenience accessor :names for :keys' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      expect(attr_test.attributes.names).to eq [ :attr1, :attr2, :attr3 ]  
    end

  end

  context 'can be accessed' do
    
    it 'to write via method with =' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      attr_test.attributes.names.each do |attr|
        attr_test.send("#{attr}=", attr.to_s.upcase)
      end
      attr_test.attributes.each do |name,value|
        expect(value).to eq name.to_s.upcase
      end
    end

    it 'to write via method without =' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      attr_test.attributes.names.each do |attr|
        attr_test.send(attr, attr.to_s.upcase)
      end
      attr_test.attributes.each do |name,value|
        expect(value).to eq name.to_s.upcase
      end
    end

    it 'to read via method' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      attr_test.attributes.names.each do |attr|
        attr_test.send(attr, attr.to_s.upcase)
      end
      attr_test.attributes.each do |name,value|
        expect(eval("attr_test.#{name}")).to eq value
      end
    end

  end

  context 'can be defined' do

    it 'via "attribute"' do
      attr_test = AttrTest.new
      attr_test.attribute :open
      expect(attr_test.open).to be_nil
      attr_test.open = true
      expect(attr_test.open).to be true
    end

    it 'attribute list can be added to' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      attr_test.attributes :attr4, :attr5, :attr6
      expect(attr_test.attributes.count).to eq 6
      expect(attr_test.attributes.names).to eq [ :attr1, :attr2, :attr3, :attr4, :attr5, :attr6 ]
    end

    it 'attribute list can be added to without duplication' do
      attr_test = AttrTest.new
      attr_test.attributes :attr1, :attr2, :attr3
      attr_test.attributes :attr2, :attr3, :attr4
      expect(attr_test.attributes.count).to eq 4
      expect(attr_test.attributes.names).to eq [ :attr1, :attr2, :attr3, :attr4 ]
    end
        
    it 'with a default value (non-hash)' do
      attr_test = AttrTest.new
      attr_test.attributes attr_with_array___default: [ 1, 2, 3 ]
      attr_test.attributes attr_with_number__default: 12345
      attr_test.attributes attr_with_string__default: "abcde"
      attr_test.attributes attr_with_boolean_default: true
      expect(attr_test.attr_with_array___default).to eq [ 1, 2, 3 ]
      expect(attr_test.attr_with_number__default).to eq 12345
      expect(attr_test.attr_with_string__default).to eq "abcde"
      expect(attr_test.attr_with_boolean_default).to eq true
    end

    context 'wth a dynamic value' do

      context 'a proc' do

        it 'runs' do
          attr_test = AttrTest.new
          attr_test.attributes attr_with_proc_default: proc { Time.now }
          expect(attr_test.attr_with_proc_default).to be < Time.now
        end

        it 'runs in instance scope' do
          attr_test = AttrTest.new
          attr_test.define_singleton_method(:my_method) { "okay" }
          attr_test.attributes attr_with_proc_default: proc { |this| this.my_method }
          expect(attr_test.attr_with_proc_default).to eq "okay"
        end

        it 'runs on each access via method' do
          attr_test = AttrTest.new
          attr_test.attributes time_proc: proc { Time.now }
          old_time = attr_test.time_proc
          expect(attr_test.time_proc).to be > old_time
        end

        it 'is returned on direct access to attribute' do
          attr_test = AttrTest.new
          attr_test.attributes time_proc: proc { Time.now }
          expect(attr_test.attributes[:time_proc]).to respond_to :call
        end

      end

      context 'a lambda' do
        
        it 'runs' do
          attr_test = AttrTest.new
          attr_test.attributes attr_with_lambda_default: lambda { Time.now }
          expect(attr_test.attr_with_lambda_default).to be < Time.now
        end

        it 'runs in instance scope' do
          attr_test = AttrTest.new
          attr_test.define_singleton_method(:my_method) { "okay" }
          attr_test.attributes attr_with_lambda_default: lambda { |this| this.my_method }
          expect(attr_test.attr_with_lambda_default).to eq "okay"
        end

        it 'runs on each access via method' do
          attr_test = AttrTest.new
          attr_test.attributes time_lambda: lambda { Time.now }
          old_time = attr_test.time_lambda
          expect(attr_test.time_lambda).to be > old_time
        end

        it 'is returned on direct access to attribute' do
          attr_test = AttrTest.new
          attr_test.attributes time_lambda: lambda { Time.now }
          expect(attr_test.attributes[:time_lambda]).to respond_to :call
        end

      end
      
      context 'a block' do

        it 'runs' do
          attr_test = AttrTest.new
          attr_test.attribute( :attr_with_block_default ) { Time.now }
          expect(attr_test.attr_with_block_default).to be < Time.now
        end

        it 'runs in instance scope' do
          attr_test = AttrTest.new
          attr_test.define_singleton_method(:my_method) { "okay" }
          attr_test.attribute( :attr_with_block_default )  { |this| this.my_method }
          expect(attr_test.attr_with_block_default).to eq "okay"
        end

        it 'runs on each access via method' do
          attr_test = AttrTest.new
          attr_test.attribute( :time_block ) { Time.now }
          old_time = attr_test.time_block
          expect(attr_test.time_block).to be > old_time
        end

        it 'is returned on direct access to attribute' do
          attr_test = AttrTest.new
          attr_test.attribute( :time_block ) { Time.now }
          expect(attr_test.attributes[:time_block]).to respond_to :call
        end

      end

    end

  end

  context 'listeners' do

    let(:lat) { AttrTest.new }
    let(:listener_class) do
      class AttrListenerTest
        attr_reader :changed_attribute, :changed_value
        def notify attr,value
          @changed_attribute = attr
          @changed_value = value
        end
      end
      AttrListenerTest
    end

    before :each do
      lat.attribute say: "Hello"
    end

    it 'are notified of attribute changes' do
      expect(lat.say).to eq "Hello"
      lat.attributes.add_listener :say, lat
      expect{ lat.say "Bye" }.to raise_exception RuntimeError, '#notify not implemented'
    end

    it 'are not notified if value does not change' do
      expect(lat.say).to eq "Hello"
      lat.attributes.add_listener :say, lat
      expect{ lat.say "Hello" }.to_not raise_exception
    end

    it 'are notified with attribute and value' do
      expect(lat.say).to eq "Hello"
      listener = listener_class.new
      lat.attributes.add_listener :say, listener
      expect{ lat.say "Bye" }.to_not raise_exception
      expect(listener.changed_attribute).to eq :say
      expect(listener.changed_value).to eq "Bye"
    end

    it 'may be multiple' do
      expect(lat.say).to eq "Hello"
      listener1 = listener_class.new
      lat.attributes.add_listener :say, listener1
      listener2 = listener_class.new
      lat.attributes.add_listener :say, listener2
      expect{ lat.say "Bye" }.to_not raise_exception
      expect(listener1.changed_attribute).to eq :say
      expect(listener1.changed_value).to eq "Bye"
      expect(listener2.changed_attribute).to eq :say
      expect(listener2.changed_value).to eq "Bye"
    end

  end

  context 'tracker' do

    let(:tat) { AttrTest.new }

    before :each do
      tat.attributes :one, :two, :three
    end

    it 'can track changes' do
      expect(tat.tracker).to eq nil
      tat.track
      expect(tat.tracker).to be_instance_of Woyo::Attributes::Tracker
      expect(tat.tracker.changed).to be_kind_of Hash
      expect(tat.tracker.changed).to be_empty
      tat.one = 1
      tat.two = 2
      expect(tat.tracker.changed.count).to eq 2
      expect(tat.tracker.changed[:one]).to eq 1
      expect(tat.tracker.changed[:two]).to eq 2
    end

    it 'can clear changes' do
      tat.track
      tat.three = 3
      expect(tat.tracker.changed[:three]).to eq 3
      tat.tracker.clear
      expect(tat.tracker.changed).to be_empty
      tat.one = 1
      expect(tat.tracker.changed[:one]).to eq 1
    end

  end

  context 'that are boolean have convenient instance accessors' do

    let(:bat) { class BooleanAttrTest; include Woyo::Attributes; end.new }

    before :each do
      bat.attribute open: true
    end

    it '#attr?' do
      expect(bat.open).to eq true
      expect(bat.open?).to eq true
    end

    it '#attr!' do
      bat.open = false
      expect(bat.open).to eq false
      expect(bat.open!).to eq true
      expect(bat.open).to eq true
    end

    it '#is? :attr' do
      expect(bat.is?(:open)).to eq true
      bat.open = false
      expect(bat.is?(:open)).to eq false
    end

    it '#is :attr' do
      bat.open = false
      expect(bat.open).to eq false
      bat.is(:open)
      expect(bat.open).to eq true
    end

  end

  context 'can be re-defined' do

    let(:ard) { AttrTest.new }

    it 'without duplication' do
      ard.attribute :attr
      ard.attribute :attr
      expect(ard.attributes.count).to eq 1
      expect(ard.attributes.names).to eq [:attr] 
      expect(ard.attr).to eq nil 
    end

    it 'to set default' do
      ard.attribute :attr
      ard.attribute :attr => 'default'
      expect(ard.attributes.count).to eq 1
      expect(ard.attributes.names).to eq [:attr] 
      expect(ard.attr).to eq 'default' 
    end

    it 'to change default'  do
      ard.attribute :attr => 'old_default'
      ard.attribute :attr => 'new_default'
      expect(ard.attributes.count).to eq 1
      expect(ard.attributes.names).to eq [:attr] 
      expect(ard.attr).to eq 'new_default' 
    end

  end

  context 'groups' do

    let(:gat) { AttrTest.new }

    before :each do
      gat.group :stooges, :larry, :curly, :moe
    end

    it 'can be accessed by named instance methods' do
      expect(gat.stooges).to be_instance_of Woyo::Attributes::Group
    end

    it 'names and nil values can be retrieved' do
      expect(gat.stooges).to be_instance_of Woyo::Attributes::Group
      expect(gat.stooges.count).to eq 3
      expect(gat.stooges.names).to eq [ :larry, :curly, :moe ] 
      expect(gat.stooges.values).to eq [ nil, nil, nil ] 
    end

    it 'names and default values can be retrieved' do
      gat.group :numbers, one: 1, two: 2, three: 3  
      expect(gat.numbers).to be_instance_of Woyo::Attributes::Group
      expect(gat.numbers.count).to eq 3
      expect(gat.numbers.names).to eq [ :one, :two, :three ]  
      expect(gat.numbers.values).to eq [ 1, 2, 3 ]
    end

    it 'members can be accessed via group' do
      expect(gat.stooges[:curly]).to eq nil
      gat.stooges[:curly] = 'bald'
      expect(gat.stooges[:curly]).to eq 'bald'
    end

    it 'members are attributes' do
      expect(gat.attributes.keys).to eq [ :larry, :curly, :moe ]  
      gat.stooges[:larry] = 'knucklehead'
      expect(gat.larry).to eq 'knucklehead' 
    end

    it 'attributes are members' do
      gat.moe = 'smart'
      expect(gat.stooges[:moe]).to eq 'smart'
    end

    it '#groups returns hash with names and groups' do
      gat.group :numbers, one: 1, two: 2, three: proc { 3 } 
      expect(gat.groups).to eq( { stooges: gat.stooges, numbers: gat.numbers } )
    end

  end

  context 'exclusions' do

    let(:xat) { AttrTest.new }

    before :each do
      xat.exclusion :temp, :warm, :cool, :cold
    end

    it 'can be accessed by named instance methods' do
      expect(xat.temp).to be_instance_of Woyo::Attributes::Exclusion
    end

    it 'first member is true, rest are false' do
      expect(xat.temp[:warm]).to eq true
      expect(xat.temp[:cool]).to eq false
      expect(xat.temp[:cold]).to eq false
    end

    it '#value returns true member' do
      expect(xat.temp.value).to eq :warm
      xat.temp[:cold] = true
      expect(xat.temp.value).to eq :cold
    end

    it 'making group member true affects member attributes' do
      xat.temp[:cold] = true
      expect(xat.cold).to be true
      expect(xat.cool).to be false
      expect(xat.warm).to be false
    end

    it 'making attribute true affects group members' do
      xat.cool = true
      expect(xat.temp[:cold]).to be false
      expect(xat.temp[:cool]).to be true
      expect(xat.temp[:warm]).to be false
    end

    it '#exclusions returns hash with names and exlcusions' do
      xat.exclusion :light, :dark, :dim, :bright
      expect(xat.exclusions).to eq( { temp: xat.temp, light: xat.light } )
    end

  end

  context 'with Hash value' do

    let(:hat) { AttrTest.new }

    before :each do
      hat.attributes :reaction, :hot, :warm, :cool, :cold
    end

    it 'accept a hash as value' do
      expect { hat.reaction hot: 'Sweat', warm: 'Relax', cool: 'Huddle', cold: 'Shiver', not_attr: 'Nothing' }.to_not raise_error
    end

    it 'return a list values of the multiple keys that are truthy attributes' do
      hat.reaction hot: 'Sweat', warm: 'Relax', cool: 'Huddle', cold: 'Shiver' 
      expect(hat.reaction).to eq [ ]
      hat.cold = true
      hat.cool = proc { 'truthy' }
      hat.warm = proc { nil } # falsey
      hat.hot  = false
      expect(hat.reaction).to eq [ 'Huddle', 'Shiver' ]
    end

    it 'return a single value of a single key that is a truthy attribute' do
      hat.reaction hot: 'Sweat', warm: 'Relax', cool: 'Huddle', cold: 'Shiver' 
      expect(hat.reaction).to eq [ ]
      hat.warm = true
      expect(hat.reaction).to eq 'Relax'
    end

    it 'returns empty list if no keys are truthy attributes' do
      hat.reaction hot: 'Sweat', warm: 'Relax', cool: 'Huddle', cold: 'Shiver' 
      expect(hat.reaction).to eq [ ]
    end

  end

end

