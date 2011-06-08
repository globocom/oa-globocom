module OmniAuth
  module Strategies
    module CadunHelper
      def client_ip(env)
        if env['HTTP_X_FORWARDED_FOR'] and not env['HTTP_X_FORWARDED_FOR'].empty?
          ips = env['HTTP_X_FORWARDED_FOR'].split(',')
          return ips.last.strip
        end
        env['REMOTE_ADDR']
      end
    end
  end
end
