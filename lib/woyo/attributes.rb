
module Attributes

  module ClassMethods

    @@attributes = []

    def attributes *attrs
      return @@attributes if attrs.empty?
      @@attributes = attrs
      @@attributes.each do |attr|
        class_eval("
          def #{attr}= arg
            attributes[:#{attr}] = @#{attr} = arg
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
    end

  end 

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def attributes
    @attributes ||= {}
  end

end

