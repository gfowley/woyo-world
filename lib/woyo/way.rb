require_relative 'attributes'

module Woyo

class Way
  
  include Attributes

  attributes :name, :description

  attr_reader :id, :from
  attr_accessor :_test

  def initialize id, from: nil, &block
    @id = id.to_s.downcase.to_sym
    @from = from
    @attributes = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  def world
    @from ? @from.world : nil
  end

  def to= arg
    #@to = arg
    if arg.instance_of? Symbol
      case
      when from && arg == from.id
        @to = from                        # way loops back to the same location
      when world && world.locations[arg]
        @to = world.locations[arg]        # destination location already exists in world
      when world
        @to = world.location arg          # create destination location in world 
      else
        @to = Location.new arg            # create free-standing destination location
      end
    end
  end

  def to arg=nil
    if arg.nil?
      @to
    else
      self.to = arg
    end
  end

end

end

