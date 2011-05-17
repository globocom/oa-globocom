$:.push File.expand_path('lib', __FILE__)

require 'uri'
require 'cgi'
require 'net/http'
require 'nokogiri'
require 'date'
require 'oa-core'
require 'cadun'
require 'omni_auth/strategies/cadun'

module OACadun
  VERSION = '0.2'
end