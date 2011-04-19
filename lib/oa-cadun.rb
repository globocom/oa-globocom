$:.push File.expand_path("lib", __FILE__)

require 'uri'
require 'cgi'
require 'net/http'
require "oa-cadun/gateway"
require "omni_auth/strategies/cadun"