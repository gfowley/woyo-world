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
      expect(result).to be evt
    end

    it 'passes self to block with arity 1' do
      evt = EvalTest.new
      result = evt.evaluate { |scope| expect(scope).to be evt }
      expect(result).to be evt
    end

  end

  it 'can list classes to contain' do
    expect(EvalTest.children).to eq [ :dog, :cat ]
  end

  it 'can add classes to contain' do
    class EvalTest
      children :cow
      children :duck
    end
    # class Cow  ; def initialize id, context: nil ; end ; end
    # class Duck ; def initialize id, context: nil ; end ; end
    expect(EvalTest.children).to eq [ :dog, :cat, :cow, :duck ]
  end

  it 'can create child objects' do
    evt = EvalTest.new
    dog = evt.dog :brown
    expect(dog).to be_instance_of Dog
    expect(evt.dog(:brown)).to be dog
    expect(evt.dogs[:brown]).to be dog
  end

  it 'has hashes of each class of child objects' do
    evt = EvalTest.new
    dog_brown = evt.dog :brown
    dog_black = evt.dog :black
    cat_white = evt.cat :white
    cat_black = evt.cat :black
    expect(evt.dogs).to eq Hash[ brown: dog_brown, black: dog_black ]
    expect(evt.cats).to eq Hash[ white: cat_white, black: cat_black ]
  end

  it 'hash a hash of all classes of child objects' do
    evt = EvalTest.new
    dog_brown = evt.dog :brown
    dog_black = evt.dog :black
    cat_white = evt.cat :white
    cat_black = evt.cat :black
    expect(evt.children.keys).to eq [ :dog, :cat ]
    cats = Hash[ white: cat_white, black: cat_black ]
    dogs = Hash[ brown: dog_brown, black: dog_black ]
    expect(evt.children).to eq Hash[ dog: dogs, cat: cats ] 
  end

end
