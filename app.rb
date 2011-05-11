require 'oa-cadun'
require 'sinatra'

use Rack::Session::Cookie
use OmniAuth::Strategies::Cadun, "2931", :full => true

include OACadun::Sinatra::Helper

get '/auth/:provider/callback' do
  p request.env['omniauth.auth']
  
  if request.env['omniauth.auth'][:user_info] and request.env['omniauth.auth'][:user_info][:status] == "AUTORIZADO"
    session[:user_info] = request.env['omniauth.auth'][:user_info]
    session[:GLBID] = request.env['omniauth.auth'][:GLBID]
  end
end

get '/' do
  p request.cookies['GLBID']
  
  # login_required
  
  session[:user_info][:username]
end