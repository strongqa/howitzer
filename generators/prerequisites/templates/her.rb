# For more information about configuration please refer to https://github.com/remiprev/her
require 'her'

# This class describes token authentication
class TestTokenAuthentication < Faraday::Middleware
  def call(env)
    if settings.app_api_token.present?
      env[:request_headers]['Authorization'] = "Token token=#{settings.app_api_token}"
    end
    @app.call(env)
  end
end

Her::API.setup url: "#{Howitzer.app_uri.site}/#{settings.app_api_end_point}" do |c|
  c.use TestTokenAuthentication
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::DefaultParseJSON
  c.use Faraday::Adapter::NetHttp
end
