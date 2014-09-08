require_relative 'world_object'
require_relative 'action'
require_relative 'location'
require_relative 'way'
require_relative 'item'
require_relative 'character'

module Woyo

class World < WorldObject

  children :location, :character, :item

  def initialize_object
    super
    attributes :start
  end

  def initialize id = nil, &block
    super id, context: nil, &block
  end

end

end
