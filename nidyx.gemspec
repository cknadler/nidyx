# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "nidyx/version"

spec = Gem::Specification.new do |s|
  s.name        = "nidyx"
  s.version     = Nidyx::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Knadler"]
  s.email       = "takeshi91k@gmail.com"
  s.homepage    = "https://github.com/cknadler/nidyx"
  s.summary     = "Nidyx"
  s.description = "JSON Schema -> Objective-C model generator"
  s.license     = "MIT"

  s.add_dependency "mustache", "~> 0.99.5"

  s.add_development_dependency "guard"
  s.add_development_dependency "ruby_gntp"
  s.add_development_dependency "guard-minitest"

  s.bindir           = "bin"
  s.require_paths    = ["lib"]
  s.executables      = ["nidyx"]
  s.files            = Dir["lib/**/*"]
  s.test_files       = Dir["test/**/test*"]
  s.extra_rdoc_files = ["README.md","LICENSE"]
end
