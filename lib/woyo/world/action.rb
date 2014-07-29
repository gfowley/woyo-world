require_relative 'world_object'

module Woyo

class Action < WorldObject

  def initialize_object
    super
    attribute :describe
    exclusion :result, :success, :failure
    @proc = nil
  end

  def execute
    proc_result = if @proc.arity < 1
      @context.instance_eval &@proc
    else
      @context.instance_exec self, &@proc
    end
    if proc_result.kind_of? Symbol
      unless exclusion(:result).members.include? proc_result
        raise "action result #{proc_result.inspect} not an expected result... #{exclusion(:result).members.inspect}"   
      end
      send proc_result, true 
      { result: result.value, describe: describe, execution: proc_result }
    else
      { result: result.value, describe: describe, execution: proc_result }
    end
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

