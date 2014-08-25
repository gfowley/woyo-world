require 'spec_helper'
require 'woyo/world/action'

describe Woyo::Action do

  let( :action ) { Woyo::Action.new :test }

  context 'has exclusions' do

    context ':result' do

      it 'exists' do
        expect(action.exclusions.names).to include :result
      end

      it 'has no members' do
        expect(action.result.members).to be_empty 
      end

    end

  end

  context "execution may be defined" do

    it "as a block" do
      action.execution { :answer } 
      expect(action.execution).to be_instance_of Proc
    end

  end

  context "executed" do

    it 'by calling #execution directly' do
      action.execution { :answer } 
      expect(action.execution.call).to eq :answer 
    end

    it 'calling #execution returns nil by default' do
      expect(action.execution.call).to be_nil
    end

    context 'by calling #execute wrapper' do

      context 'with result exclusion' do

        it 'returns result hash with single values for single truthy result' do
          action.exclusion :result, :success, :failure
          action.execution { |action| action.success! } 
          action.describe success: "Succeeded"
          expect(action.execute).to eq( { result: :success, describe: "Succeeded", execution: true, changes: {} } )
        end

        it 'returns result hash with empty results for empty result exclusion' do
          action.describe "Empty"
          expect(action.execute).to eq( { result: nil, describe: "Empty", execution: nil, changes: {} } )
        end

      end

      context 'with changes' do

        it 'returns hash of changed attributes' do
          action.attributes :a, :b ,:c
          action.changes.clear
          action.execution { |action| action.a true ; action.b false }
          expect(action.execute).to eq( { result: nil, describe: nil, execution: false, changes: { a: true, b: false } } )
        end

      end

      context 'with result group' do

        it 'returns result hash with single value for single truthy result' do
          action.group :result, a: false, b: true, c: false
          action.describe a: 'aaa', b: 'bbb', c: 'ccc'
          expect(action.execute).to eq( { result: :b, describe: 'bbb', execution: nil, changes: {} } )
        end

        it 'returns result hash with multiple values for multiple truthy results' do
          action.group :result, a: true, b: false, c: true
          action.describe a: 'aaa', b: 'bbb', c: 'ccc'
          expect(action.execute).to eq( { result: [ :a, :c ], describe: [ 'aaa', 'ccc' ], execution: nil, changes: {} } )
        end

        it 'returns result hash with empty results for empty result group' do
          action.describe "Empty"
          expect(action.execute).to eq( { result: nil, describe: "Empty", execution: nil, changes: {} } )
        end

        it 'returns result hash with empty results for no truthy results' do
          action.group :result, a: false, b: false, c: false
          action.describe "Empty"
          expect(action.execute).to eq( { result: nil, describe: "Empty", execution: nil, changes: {} } )
        end

      end

    end

  end

end

