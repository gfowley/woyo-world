RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

RSpec.configure do |config|

  config.around :example do |example|
    @example = example
    @example.metadata[:specdoc] = {}

    def heading text
      @example.metadata[:specdoc][:heading] = text
    end

    def introduction text
      @example.metadata[:specdoc][:introduction] = text
    end

    def before_code text
      @example.metadata[:specdoc][:before_code] = text
    end

    def code text = nil
      @example.metadata[:specdoc][:code] = text if text 
      @example.metadata[:specdoc][:code]
    end

    def after_code text
      @example.metadata[:specdoc][:after_code] = text
    end

    def before_results text
      @example.metadata[:specdoc][:before_results] = text
    end

    def results array = nil
      if array
        @example.metadata[:specdoc][:results] = array
        results.each do |result|
          expect(eval result[:code]).to eq eval result[:value] 
        end
      end
      @example.metadata[:specdoc][:results]
    end

    def after_results text
      @example.metadata[:specdoc][:after_results] = text
    end

    def conclusion text
      @example.metadata[:specdoc][:conclusion] = text
    end

    example.run

  end

end

class RSpec::Core::ExampleGroup

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

