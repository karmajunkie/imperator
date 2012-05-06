# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "commando/version"

Gem::Specification.new do |s|
  s.name        = "commando"
  s.version     = Commando::VERSION
  s.authors     = ["Keith Gaddis"]
  s.email       = ["keith.gaddis@gmail.com"]
  s.homepage    = "http://github.com/karmajunkie/commando"
  s.summary     = %q{Commando supports the command pattern}
  s.description = %q{Commando is a small gem to help with command objects. The command pattern is a design pattern used to encapsulate all of the information needed to execute a method or process at a point in time. In a web application, commands are typically used to delay execution of a method from the request cycle to a background processor.}

  #s.rubyforge_project = "commando"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "active_attr"
end
