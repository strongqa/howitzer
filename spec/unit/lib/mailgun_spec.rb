require 'spec_helper'

describe "Root library loading" do
  before { allow(self).to receive(:require) { true }}
  it "shoud be loaded once" do
    expect(self).to receive(:require).with('active_resource').once
    expect(self).to receive(:require).with('rest-client').once
    load '/lib/howitzer/utils/email/mailgun.rb'
  end
end

describe "Check mailgun" do

  #class Mailgun
  #
  #  def self.init(api_key, api_url = "https://mailgun.net/api/")
  #    MailgunResource.password = api_key
  #    api_url = api_url.gsub(/\/$/, '') + "/"
  #    MailgunResource.site = api_url
  #  end
  #
  #  # This is a patch of private ActiveResource method.
  #  # It takes HTTPResponse and raise AR-like error if response code is not 2xx
  #  def self.handle_response(response)
  #    case response.code.to_i
  #      when 301,302
  #        raise(Redirection.new(response))
  #      when 200...400
  #        response
  #      when 400
  #        raise(ActiveResource::BadRequest.new(response))
  #      when 401
  #        raise(ActiveResource::UnauthorizedAccess.new(response))
  #      when 403
  #        raise(ActiveResource::ForbiddenAccess.new(response))
  #      when 404
  #        raise(ActiveResource::ResourceNotFound.new(response))
  #      when 405
  #        raise(ActiveResource::MethodNotAllowed.new(response))
  #      when 409
  #        raise(ActiveResource::ResourceConflict.new(response))
  #      when 410
  #        raise(ActiveResource::ResourceGone.new(response))
  #      when 422
  #        raise(ActiveResource::ResourceInvalid.new(response))
  #      when 401...500
  #        raise(ActiveResource::ClientError.new(response))
  #      when 500...600
  #        raise(ActiveResource::ServerError.new(response))
  #      else
  #        raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
  #    end
  #  end
  #
  #  module RequestBuilder
  #    def prepare_request(url_string)
  #      uri = URI.parse(url_string)
  #      http = Net::HTTP.new(uri.host, uri.port)
  #      http.use_ssl = true if uri.port == 443
  #      return [http, (uri.path + '?' + uri.query)]
  #    end
  #  end
  #end

end