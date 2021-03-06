# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "nidyx/version"

Gem::Specification.new do |s|
  s.name        = "nidyx"
  s.version     = Nidyx::VERSION
  s.authors     = ["Chris Knadler"]
  s.email       = "takeshi91k@gmail.com"
  s.homepage    = "https://github.com/cknadler/nidyx"
  s.summary     = "JSON Schema -> Objective-C models"
  s.description = "Nidyx generates Objective-C models from JSONSchema files. Use your API's spec to make your client's models in a snap."
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.0.0"

  s.add_runtime_dependency "mustache", "~> 1.0"

  s.add_development_dependency "rake", "~> 10.5"
  s.add_development_dependency "minitest", "~> 5.8"

  s.bindir           = "bin"
  s.require_paths    = ["lib"]
  s.executables      = ["nidyx"]
  s.files            = Dir["lib/**/*", "templates/**/*"]
  s.test_files       = Dir["test/**/test*"]
  s.extra_rdoc_files = ["README.md","LICENSE"]
end
