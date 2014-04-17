
module Woyo

module DSL
  
  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

  module ClassMethods

    @contains = []   # class instance variable

    def contains *conts
      return @contains if conts.empty?
      @contains = conts              # todo: allow additions to existing @@contains
      @contains.each do |cont|
        class_eval("

          def #{cont}s
            @#{cont}s ||= {}
          end

          def #{cont} cont_or_id, &block
            #{cont} = cont_or_id.kind_of?( Woyo::#{cont.capitalize} ) ? cont_or_id : nil
            id = #{cont} ? #{cont}.id : cont_or_id
            known = self.#{cont}s[id] ? true : false
            case
            when  #{cont} &&  known &&  block_given? then #{cont}.evaluate &block
            when  #{cont} &&  known && !block_given? then #{cont}
            when  #{cont} && !known &&  block_given? then self.#{cont}s[id] = #{cont}.evaluate &block
            when  #{cont} && !known && !block_given? then self.#{cont}s[id] = #{cont}
            when !#{cont} &&  known &&  block_given? then #{cont} = self.#{cont}s[id].evaluate &block
            when !#{cont} &&  known && !block_given? then #{cont} = self.#{cont}s[id]
            when !#{cont} && !known &&  block_given? then #{cont} = self.#{cont}s[id] = Woyo::#{cont.capitalize}.new id, context: self, &block
            when !#{cont} && !known && !block_given? then #{cont} = self.#{cont}s[id] = Woyo::#{cont.capitalize}.new id, context: self
            end
            # maybe: god-like lists of everything at world level... would need unique ids... self.world.#{cont}s[id] = #{cont} if !known && self.world
            #{cont}
          end

        ")
      end
    end

  end 

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def contains
    @contains ||= {}
  end

end

end

