
require_relative 'attributes'
require_relative 'evaluate'

module Woyo

class WorldObject

  #prepend Attributes
  include Attributes
  include Evaluate

  attr_reader :id, :context
  attr_accessor :_test

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @context = context
    super  # initializes attributes
    evaluate &block
  end

end

end

