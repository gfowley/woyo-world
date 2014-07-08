
require_relative 'attributes'
require_relative 'actions'
require_relative 'evaluate'

module Woyo

class WorldObject

  include Attributes
  include Actions
  include Evaluate

  attr_reader :id, :context
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @context = context
    initialize_object
    evaluate &block
  end

  def initialize_object ; end

end

end

