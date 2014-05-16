require_relative 'world_object'

module Woyo

class Way < WorldObject

  attributes :description, name: lambda { |this| this.id.to_s.capitalize }

  attribute open: false, closed: true

  def close!
    closed!
  end

  def from
    @from ||= context
  end

  def world
    from ? from.world : nil
  end

  def to= arg
    if arg.instance_of? Symbol
      case
      when from && arg == from.id
        @to = from                        # way loops back to the same location
      when world && world.locations[arg]
        @to = world.locations[arg]        # destination location already exists in world
      when world
        @to = world.location arg          # create destination location in world 
      else
        @to = Location.new arg            # create free-standing destination location
      end
      self.open!
    else
      raise "Symbol required, but #{arg.class} : '#{arg}' given."
    end
  end

  def to arg=nil
    if arg.nil?
      @to
    else
      self.to = arg
    end
  end

end

end

