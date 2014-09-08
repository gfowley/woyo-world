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
    @id = id ? id.to_s.downcase.to_sym : nil
    @context = context
    attributes :description, name: proc { id.to_s.capitalize.gsub('_',' ') }
    initialize_object
    evaluate &block
    # todo:
    #   creating attributes should register with change listener
    #   this will catch all attributes anytime they are created
    #   instead of just after initialize->evaluate
    track_changes
  end

  def initialize_object ; end

  def uid
    if @context
      @context.uid + '-' + id.to_s
    else
      id.to_s
    end
  end

  alias_method :attribute_clear_changes, :clear_changes
  def clear_changes
    attribute_clear_changes
    children.each do |child_type,type_children|
      type_children.each do |child_id,child|
        child.clear_changes
      end
    end
  end

  alias_method :attribute_changes, :changes  
  def changes
    all_changes = attribute_changes
    children.each do |child_type,type_children|
      child_type_changes = {}
      type_children.each do |child_id,child|
        child_changes = child.changes
        child_type_changes[child_id] = child_changes unless child_changes.empty?
      end
      all_changes[child_type] = child_type_changes unless child_type_changes.empty?
    end
    all_changes
  end

end

end

