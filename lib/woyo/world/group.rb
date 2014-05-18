require 'forwardable'

module Woyo

module Attributes

  class Group

    extend Forwardable

    def_delegators :@members, :count
    def_delegators :@attributes, :[], :[]=

    attr_reader :members

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

    def initialize attributes, *members
      super
      initialize_members
    end

    def []= this_member, value
      # assuming this_member is in @members for now
      super
      # assuming value==true for now
      @members.each { |member| super(member,false) unless member == this_member }
    end
    
    private

    def initialize_members
      @members.each { |member| self[member] = false }
      self[@members.first] = true
    end

  end

end

end

