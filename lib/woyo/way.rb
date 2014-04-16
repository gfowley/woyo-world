require_relative 'attributes'
require_relative 'dsl'

module Woyo

class Way

  include DSL
  include Attributes

  attributes :name, :description

  attr_reader :id, :from
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @from = context
    @attributes = {}
    evaluate &block
  end

  def world
    @from ? @from.world : nil
  end

  def to= arg
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

