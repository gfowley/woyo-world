require_relative 'world_object'

module Woyo

class Way < WorldObject

  def initialize_object
    super
    attribute :going 
    exclusion :passable, :closed, :open  # defaults to closed: true 
    action :go do
      describe proc { self.context.going }
      #result   proc { self.context.passable } 
      execution do
        {
          go:       open?,
          location: open? ? self.to.id : nil
        }
      end
    end
  end

  # def go
  #   { go: open?, going: self.going }
  # end

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
  
end

end

