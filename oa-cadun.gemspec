# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oa-cadun/version"

Gem::Specification.new do |s|
  s.name        = "oa-cadun"
  s.version     = OACadun::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bruno Azisaka Maciel"]
  s.email       = ["bruno@azisaka.com.br"]
  s.homepage    = ""
  s.summary     = %q{OmniAuth strategy for CadUn}
  s.description = %q{The goal of this gem is to allow the developer to use CadUn (a login webservice made by Globo.com) in any web app using OmniAuth}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'oa-core'
  s.add_dependency 'cadun'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'fakeweb'
end
