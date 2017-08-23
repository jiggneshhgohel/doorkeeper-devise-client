# Reference: https://github.com/doorkeeper-gem/doorkeeper/wiki/Create-a-OmniAuth-strategy-for-your-provider
module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options, {
        :site => ::DOORKEEPER_PROVIDER_URL,
        :authorize_path => "/oauth/authorize"
      }

      uid do
        raw_info["id"]
      end

      info do
        {
          :email => raw_info["email"]
        }
      end

      def raw_info
        me_endpoint = "#{DOORKEEPER_PROTECTED_ENDPOINT_PREFIX}/me.json"
        @raw_info ||= access_token.get(me_endpoint).parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
