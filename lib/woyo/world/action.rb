require_relative 'world_object'
require_relative 'location'

module Woyo

class Action < WorldObject

  def initialize_object
    super
    attribute :describe
    @proc = proc { nil }
  end

  def execute
    location_or_context.clear_changes
    result = if @proc.arity < 1
      @context.instance_eval &@proc
    else
      @context.instance_exec self, &@proc
    end
    unless result.kind_of? Hash
      result = { return: execution_result }
    end
    # result: { location: :place } signals change of location (like going a way!)
    # todo: fill return hash with action attributes, groups, exclusions ? ...
    { describe: describe, result: result, changes: location_or_context.changes }
  end

  def execution &block
    if block_given?
      @proc = block
    else
      @proc
    end
  end

  def location_or_context
    ancestor = self 
    while ancestor.context do
      return ancestor if ancestor.kind_of? Woyo::Location
      ancestor = ancestor.context 
    end
    ancestor
  end

end

end

