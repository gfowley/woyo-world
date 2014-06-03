require_relative 'world_object'

module Woyo

class Character < WorldObject

  def initialize_object
    super
    attributes :description, name: lambda { |this| this.id.to_s.capitalize }
  end

  def world
    @world ||= context if context.is_a? World
  end

  def location
    @location ||= context if context.is_a? Location
  end

  def me
    self
  end

  def go way_or_id
    id = way_or_id.kind_of?(Way) ? way_or_id.id : way_or_id
    way = @location.ways[id]
    @location.characters.delete me.id
    @location = way.to
    @location.characters[me.id] = me
  end

end

end

