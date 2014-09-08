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
    proc_result = if @proc.arity < 1
      @context.instance_eval &@proc
    else
      @context.instance_exec self, &@proc
    end
    # result: { location: :place } signals change of location (like going a way!)
    { describe: describe, result: proc_result, changes: location_or_context.changes }
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

