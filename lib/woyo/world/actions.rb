require_relative 'attributes'

module Woyo

module Actions

  def do act
    send act
  end

  def action *attrs, &block
    actions *attrs, &block
  end

  def actions *attrs, &block
    @actions ||= Hash.new 
    return @actions if attrs.empty?
    attrs.each do |attr|
      case
      when attr.kind_of?( Hash )
        attr.each do |attr_sym,default|
          define_action_methods attr_sym, default
          @actions[attr_sym] = send "#{attr_sym}_default"
        end
      when block
        define_action_methods attr, block
        @actions[attr] = send "#{attr}_default"
      else
        unless @actions.include? attr
          define_action_methods attr
          @actions[attr] = nil
        end
      end
    end
  end

  def define_action_methods attr, default = nil
    define_action_default attr, default
    define_action_equals attr
    define_action attr
  end

  def define_action_default attr, default
    define_singleton_method "#{attr}_default" do
      default
    end
  end

  def define_action_equals attr
    define_singleton_method "#{attr}=" do |arg|
      @actions[attr] = arg
    end
  end

  def define_action attr
    define_singleton_method attr do |arg = nil|
      return @actions[attr] = arg unless arg.nil?
      case
      when @actions[attr].kind_of?( Hash )
        true_attribute_match = @actions[attr].detect { |name,value| @actions[name] == true }
        return true_attribute_match[1] if true_attribute_match
        @actions[attr]
      when @actions[attr].respond_to?( :call )
        return @actions[attr].arity == 0 ? @actions[attr].call : @actions[attr].call(self)
      else
        @actions[attr]
      end
    end
  end

end

end

