# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_naive_bayes/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_naive_bayes"
  spec.version       = SimpleNaiveBayes::VERSION
  spec.authors       = ["y42sora"]
  spec.email         = ["y42sora@y42sora.com"]
  spec.description   = %q{Simple pure ruby naive bayes}
  spec.summary       = %q{Simple pure ruby naive bayes}
  spec.homepage      = "https://github.com/y42sora/simple_naive_bayes"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
