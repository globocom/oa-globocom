require 'oa-cadun'
require 'sinatra'

use Rack::Session::Cookie
use OmniAuth::Strategies::Cadun, "2931", :full => true

get '/auth/:provider/callback' do
  if request.env['omniauth.auth'][:user_info][:username].empty?
    redirect "/auth/#{params[:provider]}"
  else
    session[:user_info] = env['omniauth.auth'][:user_info]
    redirect "/"
  end
end

get '/' do
  session[:user_info][:username]
end