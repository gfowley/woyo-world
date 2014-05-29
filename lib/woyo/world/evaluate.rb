
module Woyo

module Evaluate
  
  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  module ClassMethods

    def children *childs
      @children ||= []
      return @children if childs.empty?
      childs.each { |child| @children << child unless @children.include? child }
      @children.each do |child|
        class_eval("

          def #{child}s
            ( @children ||= {} )[:#{child}] ||= ( @#{child}s ||= {} )
          end

          def #{child} child_or_id, &block
            #{child} = child_or_id.kind_of?( #{child.capitalize} ) ? child_or_id : nil
            id = #{child} ? #{child}.id : child_or_id
            known = self.#{child}s[id] ? true : false
            case
            when  #{child} &&  known &&  block_given? then #{child}.evaluate &block
            when  #{child} &&  known && !block_given? then #{child}
            when  #{child} && !known &&  block_given? then self.#{child}s[id] = #{child}.evaluate &block
            when  #{child} && !known && !block_given? then self.#{child}s[id] = #{child}
            when !#{child} &&  known &&  block_given? then #{child} = self.#{child}s[id].evaluate &block
            when !#{child} &&  known && !block_given? then #{child} = self.#{child}s[id]
            when !#{child} && !known &&  block_given? then #{child} = self.#{child}s[id] = #{child.capitalize}.new id, context: self, &block
            when !#{child} && !known && !block_given? then #{child} = self.#{child}s[id] = #{child.capitalize}.new id, context: self
            end
            # maybe: god-like lists of everything at world level... would need unique ids... self.world.#{child}s[id] = #{child} if !known && self.world
            #{child}
          end

        ")
      end
    end

  end 

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def children
    @children ||= {}
  end

end

end

