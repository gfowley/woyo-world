
module Woyo

class Way
  
  @@attributes = [ :name, :to, :description ]

  @@attributes.each do |attr|
    self.class_eval("
      def get_#{attr}
        @#{attr}
      end
      def set_#{attr} arg
        @attributes[:#{attr}] = @#{attr} = arg
      end
      def #{attr}= arg
        before_set_#{attr} arg if respond_to? :before_set_#{attr}
        set_#{attr} arg
        after_set_#{attr} arg if respond_to? :after_set_#{attr}
      end
      def #{attr}(arg=nil)
        if arg.nil?
          get_#{attr}
        else
          before_set_#{attr} arg if respond_to? :before_set_#{attr}
          set_#{attr} arg
          after_set_#{attr} arg if respond_to? :after_set_#{attr}
        end
      end
    ")
  end

  def self.attributes
    @@attributes
  end

  attr_reader :id, :attributes, :from
  attr_accessor :_test

  def initialize id, from: nil, &block
    @id = id.to_s.downcase.to_sym
    @from = from
    @attributes = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  def world
    @from ? @from.world : nil
  end

  def after_set_to arg
    if arg.instance_of? Symbol
      case
      when from && arg == from.id
        set_to from                        # way loops back to the same location
      when world && world.locations[arg]
        set_to world.locations[arg]        # destination location already exists in world
      when world
        set_to world.location arg          # create destination location in world 
      else
        set_to Location.new arg            # create free-standing destination location
      end
    end
  end
  
end

end

