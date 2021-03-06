# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sdf-gen/version'

Gem::Specification.new do |spec|
  spec.name          = "sdf-gen"
  spec.version       = SDFGen::VERSION
  spec.authors       = ["Kevin Gilpin"]
  spec.email         = ["kgilpin@conjur.net"]
  spec.summary       = %q{SDF configuration generator.}
  spec.homepage      = "https://github.com/conjurinc/sdf-gen"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "gli"
  spec.add_dependency "hashr"

  spec.add_development_dependency "conjur-cli"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
