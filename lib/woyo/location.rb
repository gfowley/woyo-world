
module Woyo

class Location

=begin
  [ :title, :description ].each do |attr|
    self.class_eval("def #{attr}(arg=nil); arg.nil? ? @#{attr} : (@#{attr} = arg); end")
  end
=end

  attr_reader :id

  def initialize id, &block
    @id = id.to_s.downcase.to_sym
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
  end

end

end
