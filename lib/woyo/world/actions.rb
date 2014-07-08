require_relative 'attributes'

module Woyo

module Actions

  include Attributes

  def action *acts, &block
    send :_attributes, acts, ivn: '@actions', &block
  end

  def actions *acts, &block
    send :_attributes, acts, ivn: '@actions', &block
  end

  def do act
    send act
  end

end

end

