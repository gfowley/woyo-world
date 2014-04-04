require_relative 'location'

module Woyo

class World

  attr_reader :locations, :items

  def initialize &block
    @locations = {} 
    @items = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
  end

  # loc may be a Location or Symbol/String (id) for creation of a new Location
  # optionally accepts a block to be passed to Location.new if loc is not a Location
  # todo: should also pass block to location.evaluate for existing location
  def location loc, &block
    this_location = loc.kind_of?( Location ) ? loc : Location.new( loc, &block )
    @locations[this_location.id] = this_location
    this_location
  end

end

end
