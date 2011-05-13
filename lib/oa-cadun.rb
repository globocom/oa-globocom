$:.push File.expand_path("lib", __FILE__)

require 'uri'
require 'cgi'
require 'net/http'
require 'oa-core'
require 'nokogiri'
require 'time'
require 'oa-cadun/gateway'
require 'oa-cadun/user'
require 'omni_auth/strategies/cadun'