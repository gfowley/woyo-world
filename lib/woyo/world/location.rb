require_relative 'world_object'

module Woyo

class Location < WorldObject

  children   :way

  def initialize_object
    super
    attributes :description, name: lambda { |this| this.id.to_s.capitalize }
  end

  def world
    self.context
  end

  def here
    self
  end

end

end

