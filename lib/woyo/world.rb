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

  # loc_or_id may be a Location or Symbol/String (id) for creation of a new Location
  # optionally accepts a block to be passed to Location.new/evaluate
  def location loc_or_id, &block
    location = loc_or_id.kind_of?( Location ) ? loc_or_id : nil
    id = location ? location.id : loc_or_id
    known = @locations[id] ? true : false
    case
    when  location &&  known &&  block_given? then @locations[id] = location.evaluate &block
    when  location &&  known && !block_given? then @locations[id] = location
    when  location && !known &&  block_given? then @locations[id] = location.evaluate &block
    when  location && !known && !block_given? then @locations[id] = location
    when !location &&  known &&  block_given? then @locations[id].evaluate &block
    when !location &&  known && !block_given? then @locations[id]
    when !location && !known &&  block_given? then @locations[id] = Location.new id, &block
    when !location && !known && !block_given? then @locations[id] = Location.new id
    end
  end

end

end
