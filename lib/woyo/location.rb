require_relative 'attributes'
require_relative 'dsl'

module Woyo

class Location

  include DSL
  include Attributes

  attributes :name, :description

  attr_reader :id, :ways, :world, :characters
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @world = context
    @ways = {}
    @characters = {}
    evaluate &block
  end

  def here
    self
  end

  def way way_or_id, &block
    way = way_or_id.kind_of?( Way ) ? way_or_id : nil
    id = way ? way.id : way_or_id
    known = @ways[id] ? true : false
    case
    when  way &&  known &&  block_given? then way.evaluate &block
    when  way &&  known && !block_given? then way
    when  way && !known &&  block_given? then @ways[id] = way.evaluate &block
    when  way && !known && !block_given? then @ways[id] = way
    when !way &&  known &&  block_given? then @ways[id].evaluate &block
    when !way &&  known && !block_given? then @ways[id]
    when !way && !known &&  block_given? then @ways[id] = Way.new id, context: here, &block
    when !way && !known && !block_given? then @ways[id] = Way.new id, context: here
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
    when !character &&  known &&  block_given? then character = @characters[id].evaluate &block
    when !character &&  known && !block_given? then character = @characters[id]
    when !character && !known &&  block_given? then character = @characters[id] = Character.new id, context: here, &block
    when !character && !known && !block_given? then character = @characters[id] = Character.new id, context: here
    end
    @world.characters[id] = character if @world
    character
  end

end

end
