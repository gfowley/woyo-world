require_relative 'world_object'

module Woyo

class Way < WorldObject

  attributes :description, name: lambda { |this| this.id.to_s.capitalize }

  group! :passable, :closed, :open  # defaults to closed: true 

  def world
    from ? from.world : nil
  end

  def close!
    closed!
  end

  def from
    @from ||= context
  end

  def to arg=nil
    if arg.nil?
      @to
    else
      self.to = arg
    end
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

  attribute :going 
  
  def go
    { go: open?, going: self.going }
  end

end

end

