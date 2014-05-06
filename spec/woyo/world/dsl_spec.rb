require 'woyo/world/dsl'

describe Woyo::DSL do

  before :all do
    class DSLTest
      include Woyo::DSL
      contains :dog, :cat
    end
    class Dog ; def initialize id, context: nil ; end ; end
    class Cat ; def initialize id, context: nil ; end ; end
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
    DSLTest.contains.should eq [ :dog, :cat ]
  end

  it 'can add classes to contain' do
    class DSLTest
      contains :cow
      contains :duck
    end
    # class Cow  ; def initialize id, context: nil ; end ; end
    # class Duck ; def initialize id, context: nil ; end ; end
    DSLTest.contains.should eq [ :dog, :cat, :cow, :duck ]
  end

  it 'can create contained objects' do
    dsl = DSLTest.new
    dog = dsl.dog :brown
    dog.should be_instance_of Dog
    dsl.dog(:brown).should be dog
    dsl.dogs[:brown].should be dog
  end

  it 'has hashes of each class of contained objects' do
    dsl = DSLTest.new
    dog_brown = dsl.dog :brown
    dog_black = dsl.dog :black
    cat_white = dsl.cat :white
    cat_black = dsl.cat :black
    dsl.dogs.should eq Hash[ brown: dog_brown, black: dog_black ]
    dsl.cats.should eq Hash[ white: cat_white, black: cat_black ]
  end

  it 'hash a hash of all classes of contained objects' do
    dsl = DSLTest.new
    dog_brown = dsl.dog :brown
    dog_black = dsl.dog :black
    cat_white = dsl.cat :white
    cat_black = dsl.cat :black
    dsl.contains.keys.should eq [ :dog, :cat ]
    cats = Hash[ white: cat_white, black: cat_black ]
    dogs = Hash[ brown: dog_brown, black: dog_black ]
    dsl.contains.should eq Hash[ dog: dogs, cat: cats ] 
  end

end
