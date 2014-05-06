
module Woyo

module Attributes

  module ClassMethods

=begin
    def create_attribute_methods_with_class_eval attr, default = nil
      class_eval("
        def #{attr}= arg
          attributes[:#{attr}] = arg    # @#{attr} = arg
        end
        def #{attr}(arg=nil)
          if arg.nil?
            unless attributes.has_key? :#{attr}   # set default upon first read if value has not been set (including possibly nil)
              self.#{attr} = proc{ #{default} }.call
            end
            attributes[:#{attr}]        # @#{attr}
          else
            self.#{attr} = arg
          end
        end
      ")
    end
=end

    def create_attribute_methods_with_define_method attr, default = nil
      define_method "#{attr}=" do |arg|
        attributes[attr] = arg
      end
      define_method attr do |arg = nil|
        if arg.nil?
          unless attributes.has_key? attr
            attributes[attr] = ( default.respond_to?(:call) ? default.call(self) : default )
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
      #@attributes = attrs                # todo: allow additions to existing attributes
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

