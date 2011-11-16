# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "need_to_count/version"

Gem::Specification.new do |s|
  s.name        = "need_to_count"
  s.version     = NeedToCount::VERSION
  s.authors     = ["unpatioli"]
  s.email       = ["unpatioli@gmail.com"]
  s.homepage    = "http://github.com/unpatioli/need_to_count"
  s.summary     = "Conditional counter_cache for Ruby on Rails"
  s.description = "Conditional counter_cache for Ruby on Rails which allows parent model to count child models using condition"

  s.rubyforge_project = "need_to_count"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  # ========
  # = main =
  # ========
  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
  
  # ===============
  # = development =
  # ===============
  s.add_development_dependency "rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "sqlite3-ruby"
end
