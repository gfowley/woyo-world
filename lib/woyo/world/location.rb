require_relative 'world_object'

module Woyo

class Location < WorldObject

  children   :way, :item

  def initialize_object
    super
  end

  def world
    context
  end

  def here
    self
  end

end

end

