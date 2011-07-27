# Globo.com OmniAuth

The goal of this gem is to create a bridge between Globo.com's authentication and your app through OmniAuth.

## Installation

Add into your Gemfile

    gem "oa-globocom"

## Configuration

The middleware has 2 important options: `:service_id` and `:config_file`.
:service_id is the number of your service at Globo.com.
:config_file is the YAML formatted file with the urls you want to use:

    cadun:
      logout_url: https://login.dev.globoi.com/Servlet/do/logout
      login_url: https://login.dev.globoi.com/login
      auth_url: isp-authenticator.dev.globoi.com:8280

The `config_file` must be in that format, otherwise it won't work. The final result will look like this:

    config.middleware.use OmniAuth::Strategies::GloboCom, :service_id => 1234, :config_file => "#{File.dirname(__FILE__)}/cadun.yml"

After that, you just need to follow the OmniAuth standard configuration creating a callback controller to handle the CadUn's redirect. Something like this:

    class SessionsController < ActionController::Base
      def new
        redirect_to logged_in? ? dashboard_url : '/auth/globocom'
      end

      def create
        if auth = request.env['omniauth.auth']
          user = begin
            User.find(auth['uid'])
          rescue ActiveRecord::RecordNotFound
            User.create_from_omniauth(auth)
          end

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

That way the controller will check if OmniAuth has returned the Globo.com's data, if so it will find or create an user, if not it will redirect the user back to the CadUn authentication screen.

And set your routes:

    match "/auth/cadun" => "sessions#new"
    match "/auth/cadun/callback" => "sessions#create"
    match "/auth/cadun/logout" => "sessions#destroy"


## Tips: Dynamic Service Ids

Let's say your application works with many service ids. You can work with a "SETUP" step.

Add to the configuration:

    config.middleware.use OmniAuth::Strategies::GloboCom, :service_id => 1234, :setup => true, :config => "cadun.yml"

Then add to your callback controller:

    class SessionsController < ActionController::Base
      def setup
        request.env['omniauth.strategy'].options[:service_id] = object.service_id
        render :nothing => true, :status => 404
      end
    end

It's really important to finish the action with a 404 status. It says to OmniAuth that it can go ahead and complete the flow.

The setup step can change the options of the Strategy, so you can change the service id and the redirect will go to any service you set up.