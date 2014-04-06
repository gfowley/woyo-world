
module Woyo

class Location

=begin
  [ :title, :description ].each do |attr|
    self.class_eval("def #{attr}(arg=nil); arg.nil? ? @#{attr} : (@#{attr} = arg); end")
  end
=end

  @@attributes = [ :title, :description ]

  @@attributes.each do |attr|
    self.class_eval("
      def #{attr}= arg
        @attributes[:#{attr}] = @#{attr} = arg
      end
      def #{attr}(arg=nil)
        if arg.nil?
          @#{attr}
        else
          self.#{attr} = arg
        end
      end
    ")
  end

  def self.attributes
    @@attributes
  end

  attr_reader :id, :attributes
  attr_accessor :_test

  def initialize id, &block
    @id = id.to_s.downcase.to_sym
    @attributes = {}
    evaluate &block
  end

  def evaluate &block
    (block.arity < 1 ? (instance_eval &block) : block.call(self)) if block_given?
    self
  end

end

end
