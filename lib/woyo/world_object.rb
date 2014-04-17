
require_relative 'attributes'
require_relative 'dsl'

module Woyo

class WorldObject

  include Attributes
  include DSL

  attr_reader :id, :context
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @context = context
    evaluate &block
  end

end

end

