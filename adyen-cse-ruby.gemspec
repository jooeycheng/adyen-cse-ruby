# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adyen_cse/version'

Gem::Specification.new do |spec|
  spec.name          = "adyen-cse-ruby"
  spec.version       = AdyenCse::VERSION
  spec.authors       = ["Joey Cheng"]
  spec.email         = ["jooeycheng@gmail.com"]

  spec.summary       = %q{Adyen Client-side encryption library for Ruby}
  spec.description   = %q{Adyen's Client Side Encryption (CSE) library for Ruby.}
  spec.homepage      = "https://github.com/jooeycheng/adyen-cse-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "openssl-ccm", "~> 1.2.1"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
