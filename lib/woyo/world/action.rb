require_relative 'world_object'

module Woyo

class Action < WorldObject

  def initialize_object
    super
    attribute :describe
    exclusion :result, :success, :failure
    @proc = proc { nil }
  end

  def execute
    proc_result = if @proc.arity < 1
      @context.instance_eval &@proc
    else
      @context.instance_exec self, &@proc
    end
    true_members = result.members.select { |member| result[member] }
    true_members = true_members[0] if true_members.count == 1
    { result: true_members, describe: describe, execution: proc_result }
  end

  def execution &block
    if block_given?
      @proc = block
    else
      @proc
    end
  end

end

end

