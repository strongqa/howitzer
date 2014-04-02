require 'singleton'

class MailgunConnector
  include Singleton

  attr_reader :api_key

  def client(api_key=settings.mailgun_key)
    if @api_key == api_key && @api_key
      @client
    else
      @api_key = api_key
      @client = Mailgun::Client.new(@api_key)
    end
  end

  def domain
    @domain || change_domain
  end

  def change_domain(domain_name=settings.mailgun_domain)
    @domain = domain_name
  end
end