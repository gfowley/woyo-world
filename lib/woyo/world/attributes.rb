
module Woyo

module Attributes

  module ClassMethods

    def create_attribute_methods_with_define_method attr, default = nil
      define_method "#{attr}=" do |arg|
        attributes[attr] = arg
      end
      define_method attr do |arg = nil|
        if arg.nil?
          unless attributes.has_key? attr
            if default.respond_to? :call
              if default.arity == 0
                attributes[attr] = default.call # todo: is this the same as ? ... instance_eval default 
              else
                attributes[attr] = default.call(self)
              end
            else
              attributes[attr] = default
            end
          end
          attributes[attr]
        else
          attributes[attr] = arg
        end
      end
    end

    def attributes *attrs
      @attributes ||= []
      return @attributes if attrs.empty?
      attrs.each do |attr|
        if attr.kind_of? Hash
          attr.each do |attr_sym,default_value|
            @attributes << attr_sym
            create_attribute_methods_with_define_method attr_sym, default_value
          end
        else
          @attributes << attr
          create_attribute_methods_with_define_method attr
        end
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

end

