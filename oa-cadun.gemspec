# -*- encoding: utf-8 -*-
require "#{File.dirname(__FILE__)}/lib/oa-cadun/version"

Gem::Specification.new do |s|
  s.name        = 'oa-cadun'
  s.version     = OACadun::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w(Bruno Azisaka Maciel)
  s.email       = %w(bruno@azisaka.com.br)
  s.homepage    = 'https://github.com/azisaka/oa-cadun'
  s.summary     = 'OmniAuth strategy for CadUn'
  s.description = 'The goal of this gem is to allow the developer to use CadUn (a login webservice made by Globo.com) in any web app using OmniAuth'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = %w(lib)
  
  s.add_dependency 'oa-core'
  s.add_dependency 'cadun', '0.2.4'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'fakeweb'
end
