require_relative 'attributes'
require_relative 'evaluate'

module Woyo

class WorldObject

  include Attributes
  include Evaluate

  attr_reader :id, :context
  attr_accessor :_test

  children :action

  def initialize id, context: nil, &block
    @id = id.to_s.downcase.to_sym
    @context = context
    attributes :description, name: proc { id.to_s.capitalize }
    initialize_object
    evaluate &block
    track_changes  # begin tracking attribute changes *after* world objects are initially evaluated
  end

  def initialize_object ; end

end

end

