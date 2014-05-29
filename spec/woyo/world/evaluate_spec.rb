require 'woyo/world/evaluate'

describe Woyo::Evaluate do

  before :all do
    class EvalTest
      include Woyo::Evaluate
      children :dog, :cat
    end
    class Dog ; def initialize id, context: nil ; end ; end
    class Cat ; def initialize id, context: nil ; end ; end
  end

  context '#evaluate' do

    it 'instance evals block with arity 0' do
      evt = EvalTest.new
      result = evt.evaluate { self.should == evt }
      result.should be evt
    end

    it 'passes self to block with arity 1' do
      evt = EvalTest.new
      result = evt.evaluate { |scope| scope.should be evt }
      result.should be evt
    end

  end

  it 'can list classes to contain' do
    EvalTest.children.should eq [ :dog, :cat ]
  end

  it 'can add classes to contain' do
    class EvalTest
      children :cow
      children :duck
    end
    # class Cow  ; def initialize id, context: nil ; end ; end
    # class Duck ; def initialize id, context: nil ; end ; end
    EvalTest.children.should eq [ :dog, :cat, :cow, :duck ]
  end

  it 'can create child objects' do
    evt = EvalTest.new
    dog = evt.dog :brown
    dog.should be_instance_of Dog
    evt.dog(:brown).should be dog
    evt.dogs[:brown].should be dog
  end

  it 'has hashes of each class of child objects' do
    evt = EvalTest.new
    dog_brown = evt.dog :brown
    dog_black = evt.dog :black
    cat_white = evt.cat :white
    cat_black = evt.cat :black
    evt.dogs.should eq Hash[ brown: dog_brown, black: dog_black ]
    evt.cats.should eq Hash[ white: cat_white, black: cat_black ]
  end

  it 'hash a hash of all classes of child objects' do
    evt = EvalTest.new
    dog_brown = evt.dog :brown
    dog_black = evt.dog :black
    cat_white = evt.cat :white
    cat_black = evt.cat :black
    evt.children.keys.should eq [ :dog, :cat ]
    cats = Hash[ white: cat_white, black: cat_black ]
    dogs = Hash[ brown: dog_brown, black: dog_black ]
    evt.children.should eq Hash[ dog: dogs, cat: cats ] 
  end

end
