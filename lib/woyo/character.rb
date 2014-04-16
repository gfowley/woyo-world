require_relative 'attributes'

module Woyo

class Character

  include Attributes

  attributes :name, :description

  attr_reader :id, :world, :location
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    case
    when context.is_a?( Woyo::World )    then @world    = context
    when context.is_a?( Woyo::Location ) then @location = context
    end
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  def me
    self
  end

  def go way_or_id
    id = way_or_id.kind_of?(Woyo::Way) ? way_or_id.id : way_or_id
    way = @location.ways[id]
    @location.characters.delete me.id
    @location = way.to
    @location.characters[me.id] = me
  end

end

end

