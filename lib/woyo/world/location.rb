require_relative 'world_object'

module Woyo

class Location < WorldObject

  attributes :description, name: lambda { |this| this.id.to_s.capitalize }

  contains   :way, :character

  def world
    self.context
  end

  def here
    self
  end

end

end

