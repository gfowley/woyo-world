require_relative 'location'
require_relative 'way'
require_relative 'character'
require_relative 'dsl'

module Woyo

class World

  include DSL
  contains :location, :character

  attr_reader :items

  def initialize &block
    @items = {}
    evaluate &block
  end

end

end
