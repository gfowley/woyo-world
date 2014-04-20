require 'woyo/dsl'

describe Woyo::DSL do

  before :all do
    class DSLTest
      include Woyo::DSL
      contains :cont1, :cont2, :cont3
    end
    class Cont1 ; def initialize id, context: nil ; end ; end
    class Cont2 ; def initialize id, context: nil ; end ; end
    class Cont3 ; def initialize id, context: nil ; end ; end
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

  end

  it 'can list classes to contain' do
    DSLTest.contains.should eq [ :cont1, :cont2, :cont3 ]
  end

  it 'can create instances of contained objects' do
    dsl = DSLTest.new
    cont1 = dsl.cont1 :a
    cont1.should be_instance_of Cont1
    dsl.cont1(:a).should be cont1
    dsl.cont1s[:a].should be cont1
  end

  it 'can list instances of each contained object by class' do
    dsl = DSLTest.new
    cont1a = dsl.cont1 :a
    cont1b = dsl.cont1 :b
    cont2c = dsl.cont2 :c
    cont2d = dsl.cont2 :d
    dsl.cont1s.should eq Hash[ a: cont1a, b:cont1b ]
    dsl.cont2s.should eq Hash[ c: cont2c, d:cont2d ]
  end

  it 'can list all contained objects'

end
