require_relative 'dsl_object'

module Woyo

class Location < DSLObject

  attributes :name, :description

  contains   :way, :character

  def world
    self.context
  end

  def here
    self
  end

end

end

