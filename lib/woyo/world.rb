require_relative 'location'
require_relative 'way'
require_relative 'character'
require_relative 'dsl'

module Woyo

class World

  include DSL
  contains :location

  attr_reader :items, :characters

  def initialize &block
    @items = {}
    @characters = {}
    evaluate &block
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
