require_relative 'attributes'
require_relative 'dsl'

module Woyo

class Location

  include DSL
  contains :way, :character

  include Attributes
  attributes :name, :description

  attr_reader :id, :world 
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @world = context
    evaluate &block
  end

  def here
    self
  end

end

end
