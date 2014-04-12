require_relative 'location'
require_relative 'way'
require_relative 'character'

module Woyo

class World

  attr_reader :locations, :items, :characters

  def initialize &block
    @locations = {} 
    @items = {}
    @characters = {}
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

  def character char_or_id, &block
    character = char_or_id.kind_of?( Character ) ? char_or_id : nil
    id = character ? character.id : char_or_id
    known = @characters[id] ? true : false
    case
    when  character &&  known &&  block_given? then character.evaluate &block
    when  character &&  known && !block_given? then character
    when  character && !known &&  block_given? then @characters[id] = character.evaluate &block
    when  character && !known && !block_given? then @characters[id] = character
    when !character &&  known &&  block_given? then @characters[id].evaluate &block
    when !character &&  known && !block_given? then @characters[id]
    when !character && !known &&  block_given? then @characters[id] = Character.new id, &block
    when !character && !known && !block_given? then @characters[id] = Character.new id
    end
  end

end

end
