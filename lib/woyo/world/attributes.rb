require_relative 'group'

class Hash
  alias_method :names, :keys
end

module Woyo

module Attributes

  def self.included(base)
    base.extend(ClassMethods)
  end

  def self.prepended(base)
    base.singleton_class.prepend(ClassMethods)  # base.extend(ClassMethods) also seems to work, what's the diff ?
  end
  
  def initialize *args
    initialize_attributes
    initialize_groups
    initialize_exclusive_groups
    #super # we'll need this if we prepend Attributes again 
  end

  module ClassMethods

    def create_attribute_methods attr, default = nil
      
      define_method "#{attr}_default" do
        if default.respond_to? :call
          return default.arity == 0 ? default.call : default.call(self)
        end
        default
      end

      define_method "#{attr}=" do |arg|
        attributes[attr] = arg
      end

      define_method attr do |arg = nil|
        if arg.nil?
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
      @attributes ||= []
      return @attributes if attrs.empty?
      attrs.each do |attr|
        if attr.kind_of? Hash
          attr.each do |attr_sym,default_value|
            @attributes << attr_sym
            create_attribute_methods attr_sym, default_value
          end
        else
          @attributes << attr
          create_attribute_methods attr
        end
      end
    end

    def attribute *attrs
      self.attributes *attrs
    end

    def groups
      @groups ||= {}
    end

    def group sym, *attrs
      @groups ||= {}
      group = @groups[sym] ? @groups[sym] : ( @groups[sym] = [] )
      self.attributes *attrs
      attrs.each do |attr|
        if attr.kind_of? Hash
          attr.each do |attr_sym,default_value|
            group << attr_sym
          end
        else
          group << attr
        end
      end
      define_method sym do
        groups[sym]  
      end
      group
    end

    def exclusive_groups
      @exclusive_groups ||={}
    end

    def exclusive_group sym, *attrs
      @exclusive_groups ||= {}
      group = @exclusive_groups[sym] ? @exclusive_groups[sym] : ( @exclusive_groups[sym] = [] )
      self.attributes *attrs
      attrs.each do |attr|
        if attr.kind_of? Hash
          attr.each do |attr_sym,default_value|
            group << attr_sym
          end
        else
          group << attr
        end
      end
      define_method sym do
        exclusive_groups[sym]  
      end
      group
    end

  end  # module ClassMethods

  def initialize_attributes
    @attributes = self.class.attributes.each_with_object({}) do |attr,hash|
      hash[attr] = send "#{attr}_default"
    end
  end

  def initialize_groups
    @groups = {}
    self.class.groups.each { |sym,members| @groups[sym] = Woyo::Attributes::Group.new @attributes, *members }
    @groups
  end

  def initialize_exclusive_groups
    @exclusive_groups = {}
    self.class.exclusive_groups.each { |sym,members| @exclusive_groups[sym] = Woyo::Attributes::BooleanGroup.new @attributes, *members }
    @exclusive_groups
  end

  def attributes
    @attributes
  end
  
  def groups
    @groups
  end

  def exclusive_groups
    @exclusive_groups
  end

  def is? attr
    send "#{attr}?".to_sym
  end

end

end

