require_relative 'world_object'
require_relative 'location'
require_relative 'way'
require_relative 'character'

module Woyo

class World < WorldObject

  attributes :name, :description, :start
  
  contains :location, :character

  def initialize &block
    super nil, context: nil, &block
  end

end

end
