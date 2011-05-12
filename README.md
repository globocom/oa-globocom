# CadUn OmniAuth

CadUn is an authentication service provided by Globo.com. Currently it's only available for internal services. It will be public very soon.

The goal of this gem is to create a bridge between Cadun and your app through OmniAuth.

## Installation

Add into your Gemfile

    gem "oa-cadun"
  
Then configure the middleware with the CadUn's service id

    config.middleware.use OmniAuth::Strategies::Cadun, :service_id => 1234
    
After that, you just need to follow the OmniAuth standard configuration creating a callback controller to handle the CadUn's redirect. Something like this:

    class SessionsController < ActionController::Base
      def new
        redirect_to logged_in? ? dashboard_url : '/auth/cadun'
      end

      def create
        auth = request.env['omniauth.auth']
      
        if auth and auth['id']
          user = User.find_by_id(auth['id'])
          user = User.create_from_omniauth(auth) unless user
          
          session[:user_id] = user.id
          redirect_to root_url
        else
          redirect_to '/auth/cadun'
        end
      end

      def destroy
        session.delete(:user_id)
        cookies.delete("GLBID")
        redirect_to root_url
      end
    end
    
That way the controller will check if OmniAuth has returned the CadUn's data, if so it will find or create an user, if not it will redirect the user back to the CadUn authentication screen.

And set your routes:

    match "/auth/cadun" => "sessions#new"
    match "/auth/cadun/callback" => "sessions#create"
    match "/auth/cadun/logout" => "sessions#destroy"
    

## Dynamic Service Ids

Let's say your application works with many service ids. You can work with a "SETUP" step.

Add to the configuration:

    config.middleware.use OmniAuth::Strategies::Cadun, :service_id => 1234, :setup => true
    
Then add to your callback controller:

    def setup
      request.env['omniauth.strategy'].options[:service_id] = object.service_id
      render :nothing => true, :status => 404
    end
    
It's really important to finish the action with a 404 status. It says to OmniAuth that it can go ahead and complete the flow.

The setup step can change the options of the Strategy, so you can change the service id and the redirect will go to any service you set.