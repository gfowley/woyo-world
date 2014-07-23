require 'spec_helper'
require 'woyo/world/actions'

describe Woyo::Actions do

  context "may be listed" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "intially empty" do
      expect(at.actions).to be_empty
    end

    it "single action" do
      at.action( :act1 ) { name 'Action1' }
      expect(at.actions.count).to eq 1
      expect(at.actions[:act1]). to be_instance_of Proc
    end

    it "multiple actions" do
      at.action( :act1 ) { name 'Action1' }
      at.action( :act2 ) { name 'Action2' }
      expect(at.actions.count).to eq 2
      expect(at.actions[:act2]). to be_instance_of Proc
    end

  end

  context "execution may be defined" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "via a block" do
      at.action( :sum ) { execution { 1 + 2 } } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum].execution).to be_instance_of Proc
    end

    it "via a proc" do
      at.action( :sum ) { execution( proc { 1 + 2 } ) } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum].execution).to be_instance_of Proc
    end

    it "via a lambda" do
      at.action( :sum ) { execution( lambda { |this| 1 + 2 } ) } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum].execution).to be_instance_of Proc
    end

  end

  context "may be executed" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "by name" do
      at.action( :sum ) { execution { 1 + 2 } } 
      expect(at.sum.execute).to eq 3
    end

    it "via #execute :action in containing object" do
      at.action( :sum ) { execution { 1 + 2 } } 
      expect(at.execute :sum).to eq 3
    end

  end

end

