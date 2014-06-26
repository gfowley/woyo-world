require_relative 'world_object'

module Woyo

class Item < WorldObject

  def initialize_object
    super
    attributes :description, name: lambda { |this| this.id.to_s.capitalize }
  end

  def location
    self.context
  end

end

end

