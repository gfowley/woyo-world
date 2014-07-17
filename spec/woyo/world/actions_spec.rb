require 'spec_helper'
require 'woyo/world/actions'

describe Woyo::Actions do

  context "may be listed" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "intially empty" do
      expect(at.actions).to be_empty
    end

    it "single action" do
      at.action( :act1 ) { Time.now }
      expect(at.actions.count).to eq 1
      expect(at.actions[:act1]). to be_instance_of Proc
    end

    it "multiple actions" do
      at.action( :act1 ) { Time.now }
      at.action( :act2 ) { Time.now }
      expect(at.actions.count).to eq 2
      expect(at.actions[:act2]). to be_instance_of Proc
    end

  end

  context "may be defined" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "via a block" do
      at.action( :sum ) { 1 + 2 } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum]).to be_instance_of Proc
    end

    it "via a proc" do
      at.action sum: proc { 1 + 2 } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum]).to be_instance_of Proc
    end

    it "via a lambda" do
      at.action sum: lambda { |this| 1 + 2 } 
      expect(at.actions).to include :sum
      expect(at.actions[:sum]).to be_instance_of Proc
    end

  end

  context "may be invoked" do

    let( :at ) { class ActionTest ; include Woyo::Actions ; end.new }

    it "by name" do
      at.action( :sum ) { 1 + 2 } 
      expect(at.sum).to eq 3
    end

    it "via #do :action" do
      at.action( :sum ) { 1 + 2 } 
      expect(at.do :sum).to eq 3
    end

  end

end

