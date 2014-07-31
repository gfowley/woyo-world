require 'spec_helper'
require 'woyo/world/action'

describe Woyo::Action do

  let( :action ) { Woyo::Action.new :test }

  context 'has exclusions' do

    context ':result' do

      it 'exists' do
        expect(action.exclusions.names).to include :result
      end

      context 'has members' do

        it ':success' do
          expect(action.attributes.names).to include :success
        end

        it ':failure' do
          expect(action.attributes.names).to include :failure
        end

      end

    end

  end

  context "execution may be defined" do

    it "as a block" do
      action.execution { :answer } 
      expect(action.execution).to be_instance_of Proc
    end

  end

  context "may be executed" do

    it 'by calling #execution directly' do
      action.execution { :answer } 
      expect(action.execution.call).to eq :answer 
    end

    it 'calling #execution returns nil by default' do
      expect(action.execution.call).to be_nil
    end

    context 'by calling #execute wrapper' do

      context 'with result exclusion (default)' do

        it 'returns result hash with single values for success' do
          action.execution { |this| this.success! } 
          action.describe success: "Succeeded"
          expect(action.execute).to eq( { result: :success, describe: "Succeeded", execution: true } )
        end

        it 'returns result hash with single values for failure' do
          action.execution { |this| this.failure! } 
          action.describe failure: "Failed"
          expect(action.execute).to eq( { result: :failure, describe: "Failed", execution: true } )
        end

      end

      context 'with result group' do

        it 'returns result hash with array values' do
          action.group :result, a: true, b: false, c: true
          action.describe a: 'aaa', b: 'bbb', c: 'ccc'
          expect(action.execute).to eq( { result: [ :a, :c ], describe: [ 'aaa', 'ccc' ], execution: nil } )
        end

      end

    end

  end

end

