# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panatizer/version'

Gem::Specification.new do |spec|
  spec.name          = "panatizer"
  spec.version       = Panatizer::VERSION
  spec.authors       = ["Shopify"]
  spec.email         = ["gems@shopify.com"]
  spec.description   = %q{foo}
  spec.summary       = %q{bar}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rack-test"
end
