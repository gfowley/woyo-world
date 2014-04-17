require_relative 'world_object'

module Woyo

class Location < WorldObject

  attributes :name, :description

  contains   :way, :character

  def world
    self.context
  end

  def here
    self
  end

end

end

