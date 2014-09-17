require 'spec_helper'
require 'woyo/world/action'

describe Woyo::Action do

  let( :action ) { Woyo::Action.new :test }

  context "execution may be defined" do

    it "as a block" do
      action.execution { :answer } 
      expect(action.execution).to be_instance_of Proc
    end

  end

  context "calling #execution directly" do

    it 'returns result' do
      action.execution { :answer } 
      expect(action.execution.call).to eq :answer 
    end

    it 'returns nil by default' do
      expect(action.execution.call).to be_nil
    end

  end

  context "calling #execute" do

    it 'returns a hash' do
      expect(action.execute).to eq( { describe: nil, result: { return: nil }, changes: {} } )
    end

    it 'describes execution' do
      action.describe "It works"
      expect(action.execute[:describe]).to eq( "It works" )
    end

    context 'result hash is' do

      it 'hash returned from execution' do
        action.execution { { answer: 42 } } 
        expect(action.execute[:result]).to eq( { answer: 42 } )
      end

      it 'hash with return from execution at key :return' do
        action.execution { :answer } 
        expect(action.execute[:result]).to eq( { return: :answer } )
      end

    end

    context 'changes hash is' do

      it 'changed attributes' do
        action.attributes :a, :b ,:c
        action.execution { |action| action.a true ; action.b false }
        expect(action.execute[:changes]).to eq( { a: true, b: false } )
      end

      it 'changed attributes for this execution only' do
        action.attributes :a, :b ,:count
        action.execution do |action|
          action.count ||= 0
          action.count += 1
          case action.count
          when 1 then action.a true
          when 2 then action.b true
          end
        end
        expect(action.execute[:changes]).to eq( { count: 1, a: true } )
        expect(action.execute[:changes]).to eq( { count: 2, b: true } )
      end

    end

  end

end

