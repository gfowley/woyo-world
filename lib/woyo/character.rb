
module Woyo

class Character

  @@attributes = [ :name, :description ]

  @@attributes.each do |attr|
    self.class_eval("
      def #{attr}= arg
        @attributes[:#{attr}] = @#{attr} = arg
      end
      def #{attr}(arg=nil)
        if arg.nil?
          @#{attr}
        else
          self.#{attr} = arg
        end
      end
    ")
  end

  def self.attributes
    @@attributes
  end

  attr_reader :id, :attributes, :world, :location
  attr_accessor :_test

  def initialize id, world: nil, location: nil, &block
    @id = id.to_s.downcase.to_sym
    @world = world
    @location = location
    @attributes = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

end

end
