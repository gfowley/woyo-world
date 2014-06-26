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
    @specdoc_root = []
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
    @specdoc_group << { group: this_group_specdoc }
    @specdoc_parents << @specdoc_group
    @specdoc_group = this_group_specdoc
    @specdoc_group << { description: this_group.description }
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
    unless this_specdoc.any? { |element| element[:head] }
      description = this_example.description
      this_specdoc.unshift({ head: description == description.upcase ? description : description.capitalize }) 
    end
    placeholder = @specdoc_group.detect { |element| element[:example] == false }
    if placeholder 
      placeholder[:example] = this_specdoc
    else
      @specdoc_group << { example: this_specdoc }
    end
  end

  def indent
    ':' * @specdoc_parents.count
  end
  
end

