# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vend/sync/version'

Gem::Specification.new do |spec|
  spec.name          = "vend-sync"
  spec.version       = Vend::Sync::VERSION
  spec.authors       = ["Ben Tillman"]
  spec.email         = ["ben.tillman@gmail.com"]
  spec.summary       = %q{Sync vend to postgresql}
  spec.description   = %q{Sync vend to postgresql}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "vend"
  spec.add_dependency "activerecord"
  spec.add_dependency "activerecord-import"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
