RSpec::Support.require_rspec_core "formatters/base_formatter"
RSpec::Support.require_rspec_core "formatters/console_codes"

class SpecDocFormatter < RSpec::Core::Formatters::BaseFormatter

  RSpec::Core::Formatters.register self,  
    :start,
    :example_group_started, :example_group_finished,
    :example_started, :example_passed, :example_failed, :example_pending,
    :message,
    :stop

  def initialize(output)
    super
    @group_level = 0
  end
  
  def start(start_notification)
    output.puts "### start           : -------------------------------------------------------------------- "
  end

  def stop(examples_notification)
    output.puts "### stop            : -------------------------------------------------------------------- "
  end

  def example_group_started(group_notification)
    output.puts "### group start     : #{current_indentation}#{group_notification.group.description}"
    @group_level += 1
  end

  def example_group_finished(group_notification)
    @group_level -= 1 
    output.puts "### group finish    : #{current_indentation}#{group_notification.group.description}"
  end

  def example_started(example_notification)
    output.puts "### example started : #{current_indentation}#{example_notification.example.description}"
  end

  def example_passed(example_notification)
    output.puts "### example passed  : #{current_indentation}#{example_notification.example.description}"
    output.puts example_notification.example.metadata[:specdoc]
  end

  def example_pending(example_notification)
    output.puts "### example pending : #{current_indentation}#{example_notification.example.description}"                                                                
    output.puts example_notification.example.metadata[:specdoc]
  end

  def example_failed(failed_example_notification)
    output.puts "### example failed  : #{current_indentation}#{failed_example_notification.example.description}"
    output.puts example_notification.example.metadata[:specdoc]
  end
  
  def message(message_notification)
    output.puts "### message         : #{message_notification.message}"
  end

  def current_indentation
    '  ' * @group_level
  end

end


  # def start_dump(null_notification)
  #   output.puts null_notification
  # end

  # def dump_pending(examples_notification)
  #   return if examples_notification.pending_examples.empty?
  #   output.puts examples_notification.fully_formatted_pending_examples
  # end

  # def dump_failures(examples_notification)
  #   return if examples_notification.failure_notifications.empty?
  #   output.puts examples_notification.fully_formatted_failed_examples
  # end

  # def dump_summary(summary_notification)
  #   output.puts summary_notification.fully_formatted
  # end

  # def seed(seed_notification)
  #   return unless seed_notification.seed_used?
  #   output.puts seed_notification.fully_formatted
  # end

  # def close(null_notification)
  #   return unless IO === output
  #   return if output.closed? || output == $stdout
  #   output.close
  # end

