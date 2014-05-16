
class Hash
  alias_method :names, :keys
end

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
                attributes[attr] = default.call # todo: is this the same as ? ... instance_eval &default
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
      if default == true || default == false    # boolean convenience methods
        
        define_method "#{attr}?" do
          ( send attr ) ? true : false
        end

        define_method "#{attr}!" do
          send "#{attr}=", true
        end

      end

    end

    def attributes *attrs
      @attributes ||= [] # this will become a Hash ?
      return @attributes if attrs.empty?
      attrs.each do |attr|
        if attr.kind_of? Hash
          attr.each do |attr_sym,default_value|
            @attributes << attr_sym  # this will become a Hash ?
            create_attribute_methods_with_define_method attr_sym, default_value
          end
        else
          @attributes << attr
          create_attribute_methods_with_define_method attr
        end
      end
    end

    def attribute *attrs
      self.attributes *attrs
    end

    def groups
      @groups
    end

    def group sym, *attrs
      @groups ||= {}
      group = @groups[sym] ? @groups[sym] : ( @groups[sym] = [] )
      self.attributes *attrs
      attrs.each do |attr|
        if attr.kind_of? Hash
          group += attr.keys
        else
          group << attr
        end
      end
      define_method sym do
        groups[sym]  
      end
      #group
    end

  end 

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def attributes
    @attributes ||= {} # self.class.attributes.each_with_object({}) { |attr,hash| hash[attr] =  } 
  end
  
  def groups
    return @groups if @groups
    @groups = {}
    self.class.groups.each do |sym,attrs|
      @groups[sym] = attrs.each_with_object({}) { |attr,hash| hash[attr] = send attr } 
    end
    @groups
  end

  def is? attr
    send "#{attr}?".to_sym
  end

end

end

