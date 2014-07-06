require_relative 'group'

class Hash
  alias_method :names, :keys
end

module Woyo

module Attributes

=begin

  # def self.included(base)
  #   base.extend(ClassMethods)
  # end

  # def self.prepended(base)
  #   base.singleton_class.prepend(ClassMethods)  # base.extend(ClassMethods) also seems to work, what's the diff ?
  # end
  
  # def initialize *args
  #   # initialize_attributes
  #   # initialize_groups
  #   # initialize_boolean_groups
  #   # initialize_is_overrides
  #   #super # we'll need this if we prepend Attributes again 
  # end

  # module ClassMethods

  #   # def groups
  #   #   @groups ||= {}
  #   # end

  #   # def boolean_groups
  #   #   @boolean_groups ||={}
  #   # end


  #   # def is *attrs
  #   #   @is_overrides ||= []
  #   #   attrs.each do |attr|
  #   #     @is_overrides << attr unless @is_overrides.include? attr 
  #   #     self.attribute( { attr => true } )
  #   #   end
  #   # end

  #   # def is_overrides
  #   #   @is_overrides ||= []
  #   # end

  # end  # module ClassMethods

  # def initialize_attributes
  #   @attributes = self.class.attributes.each_with_object(Woyo::Attributes::AttributesHash.new) do |attr,hash|
  #     hash[attr] = send "#{attr}_default"
  #   end
  # end

  # def initialize_groups
  #   @groups = {}
  #   self.class.groups.each { |sym,members| @groups[sym] = Woyo::Attributes::Group.new @attributes, *members }
  #   @groups
  # end

  # def initialize_boolean_groups
  #   @boolean_groups = {}
  #   self.class.boolean_groups.each { |sym,members| @boolean_groups[sym] = Woyo::Attributes::BooleanGroup.new @attributes, *members }
  #   @boolean_groups
  # end

  # def initialize_is_overrides
  #   self.class.is_overrides.each { |attr| send "#{attr}!" } 
  # end

=end

  def define_attr_methods attr, default = nil
    define_attr_default attr, default
    define_attr_equals attr
    define_attr attr
    if default == true || default == false    # boolean convenience methods
      define_attr? attr
      define_attr! attr
    end
  end

  def define_attr_default attr, default
    define_singleton_method "#{attr}_default" do
      default
    end
  end

  def define_attr_equals attr
    define_singleton_method "#{attr}=" do |arg|
      @attributes[attr] = arg
    end
  end

  def define_attr attr
    define_singleton_method attr do |arg = nil|
      return @attributes[attr] = arg unless arg.nil?
      case
      when @attributes[attr].kind_of?( Hash )
        true_attribute_match = @attributes[attr].detect { |name,value| @attributes[name] == true }
        return true_attribute_match[1] if true_attribute_match
        @attributes[attr]
      when @attributes[attr].respond_to?( :call )
        return @attributes[attr].arity == 0 ? @attributes[attr].call : @attributes[attr].call(self)
      else
        @attributes[attr]
      end
    end
  end

  def define_attr? attr
    define_singleton_method "#{attr}?" do
      ( send attr ) ? true : false
    end
  end

  def define_attr! attr
    define_singleton_method "#{attr}!" do
      send "#{attr}=", true
    end
  end

  def is? attr
    send "#{attr}?"
  end

  def is attr
    send "#{attr}=", true
  end

  def attribute *attrs, &block
    send :attributes, *attrs, &block
  end

  def attributes *attrs, &block
    @attributes ||= Woyo::Attributes::AttributesHash.new
    return @attributes if attrs.empty?
    attrs.each do |attr|
      case
      when attr.kind_of?( Hash )
        attr.each do |attr_sym,default|
          define_attr_methods attr_sym, default
          @attributes[attr_sym] = send "#{attr_sym}_default"
        end
      when block
        define_attr_methods attr, block
        @attributes[attr] = send "#{attr}_default"
      else
        unless @attributes.include? attr
          define_attr_methods attr
          @attributes[attr] = nil
        end
      end
    end
  end

  def groups
    @groups
  end

  def group sym, *attrs
    @groups ||= {}
    grp = @groups[sym] ? @groups[sym] : ( @groups[sym] = Woyo::Attributes::Group.new attributes )
    attributes *attrs
    attrs.each do |attr|
      if attr.kind_of? Hash
        attr.each do |attr_sym,default_value|
          grp << attr_sym
        end
      else
        grp << attr
      end
    end
    define_singleton_method sym do
      @groups[sym]  
    end
    grp
  end

  def exclusions
    @exclusions
  end
 
  def exclusion sym, *attrs
    @exclusions ||= {}
    exc = @exclusions[sym] ? @exclusions[sym] : ( @exclusions[sym] = Woyo::Attributes::Exclusion.new attributes )
    attributes *attrs
    attrs.each do |attr|
      define_attr? attr
      define_attr! attr
      if attr.kind_of? Hash
        attr.each do |attr_sym,default_value|
          exc << attr_sym
        end
      else
        exc << attr
      end
    end
    define_singleton_method sym do
      @exclusions[sym]
    end
    exc
  end

end

end

