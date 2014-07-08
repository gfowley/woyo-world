require_relative 'world_object'

module Woyo

class Item < WorldObject

  def initialize_object
    super
  end

  def location
    self.context.instance_of?( Location ) ? self.context : nil
  end

  def world
    case
    when self.context.instance_of?( World )   then self.context
    when self.context.instance_of?( Location) then self.context.world
    else nil
    end
  end

end

end

