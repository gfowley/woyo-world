require 'spec_helper'
require 'woyo/world/world_object'
require 'woyo/world/action'

describe Woyo::WorldObject do

  context '#new' do

    it 'initializes with symbol id' do
      expect { Woyo::WorldObject.new :my_id }.to_not raise_error
    end

    it 'creates id' do
      expect(Woyo::WorldObject.new(:my_id).id).to eq :my_id
    end

    it 'converts id to lowercase' do
      expect(Woyo::WorldObject.new(:MY_id ).id).to eq :my_id
    end

    it 'accepts named parameter context:' do
      expect { Woyo::WorldObject.new(:my_id, context: :just_a_test ) }.to_not raise_error
    end

    it 'accepts a block with arity 0' do
      result = ''
      Woyo::WorldObject.new( :home ) { result = 'ok' }
      expect(result).to eq 'ok'
    end

    it 'instance evals block with arity 0' do
      Woyo::WorldObject.new( :home ) { self.class.should == Woyo::WorldObject }
    end

    it 'accepts a block with arity 1' do
      result = ''
      Woyo::WorldObject.new( :home ) { |scope| result = 'ok' }
      expect(result).to eq 'ok'
    end

    it 'passes self to block with arity 1' do
      Woyo::WorldObject.new( :home ) { |scope| expect(scope).to be_instance_of Woyo::WorldObject }
    end

  end

  it 'provides access to context' do
    wo = Woyo::WorldObject.new(:my_id, context: :just_a_test )
    expect(wo.context).to eq :just_a_test
  end

  it 'lists children' do
    class Thing < Woyo::WorldObject ; end
    class Container < Woyo::WorldObject ; children :thing ; end
    box = Container.new :box do
      thing :ball
    end
    expect(box.children).to eq({ thing: { ball: box.thing(:ball) } })
  end

  context 'has' do

    it 'attributes' do
      wo = Woyo::WorldObject.new :thing do
        attribute color: :red
      end
      expect(wo.color).to eq :red
      wo.color = :blue
      expect(wo.color).to eq :blue
    end

    it 'actions' do
      wo = Woyo::WorldObject.new :thing do
        action :time do
          execution do
            Time.now
          end
        end
      end
      expect(wo.action(:time).execution.call).to be < Time.now
    end

  end

  context 'has attributes' do

    it 'name' do
      wo = Woyo::WorldObject.new( :thing ) { name 'Thingy' }
      expect(wo.name).to eq 'Thingy'
    end

    it 'default name' do
      wo = Woyo::WorldObject.new( :thing )
      expect(wo.name).to eq 'Thing'
    end

    it 'description' do
      wo = Woyo::WorldObject.new( :thing ) { description 'A thing.' }
      expect(wo.description).to eq 'A thing.'
    end

  end

  context 'changes' do
    
    it 'listed for own attributes' do
      wo = Woyo::WorldObject.new( :thing )
      expect(wo.changes).to be_empty
      wo.name = 'Other'
      expect(wo.changes[:name]).to eq 'Other'
    end

    it 'list includes dependent changes' do
      wo = Woyo::WorldObject.new( :thing )
      wo.exclusion :color, :red, :blue
      wo.description red: 'Red thing', blue: 'Blue thing'
      wo.changes.clear
      expect(wo.changes).to be_empty
      wo.blue = true
      expect(wo.changes.names).to include :blue
      expect(wo.changes.names).to include :description
      expect(wo.changes[:description]).to eq 'Blue thing'
    end

    it 'list recursively includes changes for children' do
      class Low < Woyo::WorldObject ; end
      class Mid < Woyo::WorldObject ; children :low ; end
      class Top < Woyo::WorldObject ; children :mid ; end
      t1 = Top.new :t1 do
        mid(:m1) { low :l1 ; low :l2 ; low :l3 } 
        mid(:m2) { low :l1 ; low :l2 ; low :l3 }
        mid(:m3) { low :l1 ; low :l2 ; low :l3 }
        mid(:m4) do
          low :l1
          low :l2 do
            exclusion :make_change, :no, :yes
            name no: 'Unchanged l2', yes: 'Changed l2'
          end
        end
      end
      t1.name = 'Changed t1'
      m1 = t1.mid(:m1)
      m2 = t1.mid(:m2)
      m4 = t1.mid(:m4)
      m1.name = 'Changed m1'
      m1.low(:l1).name = "Changed l1"
      m1.low(:l2).name = "Changed l2"
      m2.low(:l2).name = "Changed l2"
      m4.low(:l2).yes = true
      expect(t1.changes).to eq ({
        name: 'Changed t1',
        mid: { 
          m1: { name: 'Changed m1', low: { l1: { name: 'Changed l1' }, l2: { name: 'Changed l2' } } },
          m2: {                     low: { l2: { name: 'Changed l2' }                             } },
          m4: {                     low: { l2: { name: 'Changed l2', yes: true }                  } }
        }
      })
    end

  end

end

