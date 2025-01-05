# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solid_queue_pat/version'

Gem::Specification.new do |spec|
  spec.name          = "solid_queue_pat"
  spec.version       = SolidQueuePat::VERSION
  spec.authors       = ["Yoshikazu Kaneta"]
  spec.email         = ["kaneta@sitebridge.co.jp"]
  spec.summary       = %q{Some patches for solid_queue.}
  spec.description   = %q{Some patches for solid_queue.}
  spec.homepage      = "https://github.com/kanety/solid_queue_pat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "rails", ">= 7.2"
  spec.add_dependency "solid_queue", ">= 1.0"
  spec.add_dependency "get_process_mem"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "simplecov"
end
