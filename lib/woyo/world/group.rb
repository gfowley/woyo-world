require 'forwardable'

module Woyo

module Attributes

  class AttributesHash < Hash

    alias_method :names, :keys
    alias_method :set, :[]=

    attr_reader :listeners

    def initialize
      @listeners = {}
    end

    def add_attribute_listener attr, listener
      @listeners[attr] = listener
    end
    
    def []= attr, value
      old_value = self[attr]
      super
      if ( listener = @listeners[attr] ) && value != old_value
        listener.notify attr, value
      end
    end

  end

  class Group

    extend Forwardable

    def_delegators :@members, :count
    def_delegators :@attributes, :[], :[]=

    attr_reader :members, :attributes

    def initialize attributes, *members
      @attributes = attributes
      @members = members
    end

    def names
      @members
    end

    def values
      @attributes.values_at *@members
    end

  end

  class BooleanGroup < Group

    attr_reader :default 
    
    def initialize attributes, *members
      super
      @default = @members.first
      self[@default] = true
      #@members.each { |member| self[member] = false }
      @members.each { |member| @attributes.add_attribute_listener member, self }
    end

    def []= this_member, value
      raise '#{this_member} is not a member of this group' unless @members.include? this_member
      super
      if value #true
        # sync group members via AttributesHash#set to prevent triggering notify
        @members.each { |member| @attributes.set(member,false) unless member == this_member }
      else     #false
        if self.count == 2  # binary group
          @members.each { |member| @attributes.set member ,(member != this_member ) }
        else
          self[@default] = true # revert to default
        end
      end
    end

    def notify this_member, value
      # assuming value==true for now
      # sync group members via AttributesHash#set to prevent re-triggering notify
      @members.each { |member| @attributes.set(member,false) unless member == this_member }
    end
    
  end

end

end

