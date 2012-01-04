# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "birdlense/version"

Gem::Specification.new do |s|
  s.name        = "birdlense"
  s.version     = Birdlense::VERSION
  s.authors     = ["Bryan Shelton"]
  s.email       = ["bryan@sheltonplace.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "birdlense"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "flickraw"
  s.add_runtime_dependency "twitter"
  s.add_runtime_dependency "data_mapper"
  s.add_runtime_dependency "dm-migrations"
  s.add_runtime_dependency "dm-types"
  s.add_runtime_dependency "flickraw"
  s.add_runtime_dependency "hpricot"
  s.add_runtime_dependency "url_hunter"
end
