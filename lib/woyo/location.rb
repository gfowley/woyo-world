
module Woyo

class Location

  @@attributes = [ :title, :description ]

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

  attr_reader :id, :attributes, :ways
  attr_accessor :_test

  def initialize id, &block
    @id = id.to_s.downcase.to_sym
    @attributes = {}
    @ways = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  def here
    self
  end

  def way way_or_id, &block
    way = way_or_id.kind_of?( Way ) ? way_or_id : nil
    id = way ? way.id : way_or_id
    known = @ways[id] ? true : false
    case
    when  way &&  known &&  block_given? then @ways[id] = way.evaluate &block
    when  way &&  known && !block_given? then @ways[id] = way
    when  way && !known &&  block_given? then @ways[id] = way.evaluate &block
    when  way && !known && !block_given? then @ways[id] = way
    when !way &&  known &&  block_given? then @ways[id].evaluate &block
    when !way &&  known && !block_given? then @ways[id]
    when !way && !known &&  block_given? then @ways[id] = Way.new id, &block
    when !way && !known && !block_given? then @ways[id] = Way.new id
    end
  end

end

end
