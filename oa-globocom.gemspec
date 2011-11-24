# -*- encoding: utf-8 -*-
require "#{File.dirname(__FILE__)}/lib/oa-globocom/version"

Gem::Specification.new do |s|
  s.name        = 'oa-globocom'
  s.version     = OAGloboCom::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w(Bruno Azisaka Maciel)
  s.email       = %w(bruno@azisaka.com.br)
  s.homepage    = 'https://github.com/azisaka/oa-globocom'
  s.summary     = 'OmniAuth strategy for Globo.com authentication system'
  s.description = 'The goal of this gem is to allow the developer to use ContaGlobo.com (a login webservice made by Globo.com) in any web app using OmniAuth'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = %w(lib)
  
  s.add_dependency 'omniauth', '~> 1.0.0'
  s.add_dependency 'cadun', '~> 0.6.0'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'timecop'
end
