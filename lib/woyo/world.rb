require_relative 'location'
require_relative 'way'
require_relative 'character'
require_relative 'dsl'

module Woyo

class World

  include DSL

  attr_reader :locations, :items, :characters

  def initialize &block
    @locations = {} 
    @items = {}
    @characters = {}
    evaluate &block
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
    when !location && !known &&  block_given? then @locations[id] = Location.new id, context: self, &block
    when !location && !known && !block_given? then @locations[id] = Location.new id, context: self
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
    when !character && !known &&  block_given? then @characters[id] = Character.new id, context: self, &block
    when !character && !known && !block_given? then @characters[id] = Character.new id, context: self
    end
  end

end

end
