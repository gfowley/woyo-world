# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'woyo/version'

Gem::Specification.new do |spec|
  spec.name          = "woyo"
  spec.version       = Woyo::VERSION
  spec.authors       = ["Gerard Fowley"]
  spec.email         = ["gerard.fowley@iqeo.net"]
  spec.summary       = %q{World of Your Own}
  spec.description   = %q{Game world builder DSL}
  spec.homepage      = ""
  spec.license       = "LGPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test", "~> 0.6.2"

  spec.add_runtime_dependency "sinatra", "~> 1.4.5"

end
