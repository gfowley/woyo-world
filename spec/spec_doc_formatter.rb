RSpec::Support.require_rspec_core "formatters/base_formatter"
RSpec::Support.require_rspec_core "formatters/console_codes"

require 'json'
require 'haml'

class SpecDocFormatter < RSpec::Core::Formatters::BaseFormatter

  RSpec::Core::Formatters.register self,  
    :start,
    :example_group_started, :example_group_finished,
    :example_passed, :example_failed, :example_pending,
    :stop

  def initialize(output)
    super
  end
  
  def start(start_notification)
    @specdoc_root = {}
    @specdoc_root[:groups] = []
    @specdoc_group = @specdoc_root
    @specdoc_parents = []
  end

  def stop(examples_notification)
    # if option[:json]
    #output.puts json_format 
    # end
    # if option[:haml]
    output.puts haml_format
    # end
  end

  def json_format
    JSON.pretty_generate @specdoc_root
  end

  def haml_format
    Haml::Engine.new( File.read( File.join File.dirname( __FILE__ ), 'spec_doc.haml' )).render( self, specdoc: @specdoc_root )
  end

  def example_group_started(group_notification)
    this_group = group_notification.group
    this_group.init_specdoc
    this_group_specdoc = this_group.metadata[:specdoc][this_group] 
    #@specdoc_group[this_group.description] = this_group_specdoc
    @specdoc_group[:groups] << this_group_specdoc
    @specdoc_parents << @specdoc_group
    @specdoc_group = this_group_specdoc
    @specdoc_group[:description]   = this_group.description
    @specdoc_group[:heading]     ||= this_group.description.capitalize
    @specdoc_group[:examples]      = []
    @specdoc_group[:groups]        = []
  end

  def example_group_finished(group_notification)
    @specdoc_group = @specdoc_parents.pop
  end

  def example_passed(example_notification)
    collect_example example_notification, :passed
  end

  def example_pending(example_notification)
    collect_example example_notification, :pending
  end

  def example_failed(example_notification)
    collect_example example_notification, :failed
  end

  def collect_example example_notification, result
    this_example = example_notification.example
    this_specdoc = this_example.metadata[:specdoc]
    this_specdoc[:heading] ||= this_example.description.capitalize
    @specdoc_group[:examples] << this_specdoc 
  end

  def indent
    ':' * @specdoc_parents.count
  end
  
end

  # def example_started(example_notification)
  #   output.puts "### example started : #{current_indentation}#{example_notification.example.description}"
  # end

  # def message(message_notification)
  #   output.puts "### message         : #{message_notification.message}"
  # end

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

