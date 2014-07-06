require 'spec_helper'
require 'woyo/world/actions'

describe Woyo::Actions do

  before :all do
    class ActionTest
      include Woyo::Actions
    end
  end

  context "may be listed" do

    it "intially empty" do
      action_test = ActionTest.new
      expect(action_test.actions).to be_instance_of Array
      expect(action_test.actions).to be_empty
    end

    it "single action"

    it "multiple actions"

  end

  context "are defined" do

    it "via a block" do
      action_test = ActionTest.new
      action_test.action( :sum ) { 1 + 2 } 
      expect(action_test.actions).to include :sum
    end

  end

  context "may be invoked" do

    it "by name" do
      action_test = ActionTest.new
      action_test.action( :sum ) { 1 + 2 } 
      expect(action_test.sum!).to_not raise_error
      expect(action_test.sum!).to eq 3
    end

    it "via #do :action" do
      action_test = ActionTest.new
      action_test.action( :sum ) { 1 + 2 } 
      expect(action_test.do :sum).to eq 3
    end

  end

end

