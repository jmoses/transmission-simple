# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transmission-simple/version"

Gem::Specification.new do |s|
  s.name        = "transmission-simple"
  s.version     = TransmissionSimple::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Moses"]
  s.email       = ["jon@burningbush.us"]
  s.homepage    = "http://github.com/jmoses/transmission-simple"
  s.summary     = %q{Simple REST based client for Transmissions's RPC functionality}
  s.description = %q{Simple REST based client for Transmissions's RPC functionality}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'json'
  s.add_dependency 'active_support'
end
