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

  def changes
    # re-define changes method in Attributes to return changes for children too
    @changes ||= {}
    children.each do |child_type,type_children|
      child_type_changes = {}
      type_children.each do |child_id,child|
        child_changes = child.changes
        child_type_changes[child_id] = child_changes unless child_changes.empty?
      end
      @changes[child_type] = child_type_changes unless child_type_changes.empty?
    end
    @changes
  end

end

end

