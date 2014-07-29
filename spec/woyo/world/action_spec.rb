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

    it '- #execution returns nil if not defined' do
      expect(action.execution).to be_nil
    end

    context 'by calling #execute wrapper' do

      it 'returning result hash for success' do
        action.execution { |this| this.success! } 
        action.describe success: "Succeeded"
        expect(action.execute).to eq( { result: :success, describe: "Succeeded", execution: true } )
      end

      it 'returning result hash for failure' do
        action.execution { |this| this.failure! } 
        action.describe failure: "Failed"
        expect(action.execute).to eq( { result: :failure, describe: "Failed", execution: true } )
      end
   
      it 'raising error for unexpected execution result' do
        action.execution { :surprise }
        expect{ action.execute }.to_not raise_error
      end

    end

  end

end

