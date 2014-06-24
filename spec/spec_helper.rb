RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

RSpec.configure do |config|

  config.around :example do |example|
    @example = example
    #@example.metadata[:specdoc] = {}
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

    # def results array = nil
    #   if array
    #     @example.metadata[:specdoc][:results] ||= []
    #     @example.metadata[:specdoc][:results]  += array
    #     results.each do |result|
    #       if result[:value] 
    #         expect(@binding.eval result[:code]).to eq @binding.eval result[:value]
    #       else
    #         @binding.eval result[:code]
    #       end
    #     end
    #   end
    #   @example.metadata[:specdoc][:results]
    # end

    # def result rhash
    #   results [ { code: rhash.keys.first, value: rhash.values.first } ]
    # end

    # def hide
    #   @example.metadata[:specdoc][:hide] = true
    # end

    # def heading text
    #   @example.metadata[:specdoc][:heading] = text
    # end

    # def introduction text
    #   @example.metadata[:specdoc][:introduction] = text
    # end

    # def before_codes text
    #   @example.metadata[:specdoc][:before_codes] = text
    # end

    # def codes array = nil
    #   if array 
    #     @example.metadata[:specdoc][:codes] ||= []
    #     @example.metadata[:specdoc][:codes]  += array
    #     codes.each do |code|
    #       code[:code] = fix_indent(code[:code])
    #       @binding.eval code.values_at(:pre,:code,:post).join "\n"
    #     end
    #   end
    #   @example.metadata[:specdoc][:codes]
    # end

    # def code text
    #   codes [ { code: text } ]
    # end

    # def after_codes text
    #   @example.metadata[:specdoc][:after_codes] = text
    # end

    # def before_results text
    #   @example.metadata[:specdoc][:before_results] = text
    # end
    
    # def after_results text
    #   @example.metadata[:specdoc][:after_results] = text
    # end

    # def conclusion text
    #   @example.metadata[:specdoc][:conclusion] = text
    # end

  end

end

class RSpec::Core::ExampleGroup

  def eval_binding
    binding
  end

  def self.title text
    init_specdoc
    metadata[:specdoc][self][:title] = text
  end

  def self.tagline text
    init_specdoc
    metadata[:specdoc][self][:tagline] = text
  end

  def self.url text
    init_specdoc
    metadata[:specdoc][self][:url] = text
  end

  def self.hide text
    init_specdoc
    metadata[:specdoc][self][:hide] = true
  end

  def self.heading text
    init_specdoc
    metadata[:specdoc][self][:heading] = text
  end

  def self.introduction text
    init_specdoc
    metadata[:specdoc][self][:introduction] = text
  end

  def self.conclusion text
    init_specdoc
    metadata[:specdoc][self][:conclusion] = text
  end

  def self.init_specdoc
    metadata[:specdoc] = {} unless metadata[:specdoc]
    metadata[:specdoc][self] = {} unless metadata[:specdoc][self]
  end

end

