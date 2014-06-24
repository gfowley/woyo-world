RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

RSpec.configure do |config|

  config.around :example do |example|
    @example = example
    @example.metadata[:specdoc] = []
    @binding = @example.example_group_instance.eval_binding

    def head text
      @example.metadata[:specdoc] << { head: text }
    end

    def text text
      @example.metadata[:specdoc] << { text: text }
    end

    def code code
      code_hash = case
      when code.is_a?( String )
        { code: code }
      when code.respond_to?( :[] ) && code[:code]
        code
      when [:keys,:values,:count].all? { |m| code.respond_to? m } && code.count == 1
        { code: code.keys.first, value: code.values.first }
      else
        raise "Don't know what to do with: #{code}"
      end
      code_hash[:code] = fix_indent(code_hash[:code])
      @example.metadata[:specdoc] << code_hash
      exec_code code_hash
    end

    def exec_code code
      if code[:value]
        expect(@binding.eval code.values_at(:pre,:code,:post).join "\n").to self.send((code[:op] ? code[:op] : :eq),(@binding.eval code[:value]))
      else
        @binding.eval code.values_at(:pre,:code,:post).join "\n"
      end
    end

    def fix_indent text
      lines = text.lines
      leading = lines.collect { |l| l.index /[^ ]/ }
      indent = leading.reject { |n| n == 0 }.min
      if indent
        indent_regex = Regexp.new('^'+' '*indent)
        lines.each { |l| l.sub!(indent_regex,'') }
      end
      lines.join
    end

    example.run

  end

end

class RSpec::Core::ExampleGroup

  def eval_binding
    binding
  end

  def self.title title
    init_specdoc
    metadata[:specdoc][self] << { title: title }
  end

  def self.tagline tagline
    init_specdoc
    metadata[:specdoc][self] << { tagline: tagline }
  end

  def self.url url
    init_specdoc
    metadata[:specdoc][self] << { url: url }
  end

  def self.hide
    init_specdoc
    metadata[:specdoc][self] << :hide
  end

  def self.head head
    init_specdoc
    metadata[:specdoc][self] << { head: head }
  end

  def self.text text
    init_specdoc
    metadata[:specdoc][self] << { text: text }
  end

  def self.init_specdoc
    metadata[:specdoc] = {} unless metadata[:specdoc]
    metadata[:specdoc][self] = [] unless metadata[:specdoc][self]
  end

end

