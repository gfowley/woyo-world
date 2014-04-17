require 'woyo/dsl'

describe Woyo::DSL do

  before :all do
    class DSLTest
      include Woyo::DSL
      contains :cont1, :cont2, :cont3
    end
  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      dsl = DSLTest.new
      result = dsl.evaluate { self.should == dsl }
      result.should be dsl
    end

    it 'passes self to block with arity 1' do
      dsl = DSLTest.new
      result = dsl.evaluate { |scope| scope.should be dsl }
      result.should be dsl
    end

    it 'can create contained WorldObjects'

  end

end
