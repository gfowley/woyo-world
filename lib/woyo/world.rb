require_relative 'location'
require_relative 'way'

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

  def location loc_or_id, &block
    location = loc_or_id.kind_of?( Location ) ? loc_or_id : nil
    id = location ? location.id : loc_or_id
    known = @locations[id] ? true : false
    case
    when  location &&  known &&  block_given? then location.evaluate &block
    when  location &&  known && !block_given? then location
    when  location && !known &&  block_given? then @locations[id] = location.evaluate &block
    when  location && !known && !block_given? then @locations[id] = location
    when !location &&  known &&  block_given? then @locations[id].evaluate &block
    when !location &&  known && !block_given? then @locations[id]
    when !location && !known &&  block_given? then @locations[id] = Location.new id, world: self, &block
    when !location && !known && !block_given? then @locations[id] = Location.new id, world: self
    end
  end

end

end
