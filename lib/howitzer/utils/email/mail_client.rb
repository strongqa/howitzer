require 'net/pop'
require 'timeout'
require 'mail'
require 'howitzer/utils/email/mailgun_helper'

class MailClient

  extend MailgunHelper
  @clients = {}

  def self.default
    log.info "Connect to default mailbox"
    options = merge_opts
    @clients[options] = new unless @clients.has_key?(options)
    @clients[options]
  end

  def self.by_email(name)
    log.info "Connect to '#{name}' mailbox"
    options = self.merge_opts(pop3: { user_name: name }, smtp: {})
    @clients[options] = new(options) unless @clients.has_key?(options)
    @clients[options]
  end

  def self.merge_opts(opts={smtp: {}, pop3: {}})
    def_smtp_opts = {
        address: settings.mail_smtp_server,
        port: settings.mail_smtp_port,
        domain: settings.mail_smtp_domain,
        user_name: settings.mail_smtp_user_name,
        password: settings.mail_smtp_user_pass,
        authentication: 'plain',
        enable_starttls_auto: true
    }

    def_pop3_opts = {
        address: settings.mail_pop3_server,
        port: settings.mail_pop3_port,
        user_name: settings.mail_pop3_user_name,
        password: settings.mail_pop3_user_pass
    }
    {
        smtp: def_smtp_opts.merge(opts[:smtp]),
        pop3: def_pop3_opts.merge(opts[:pop3])
    }
  end

  def find_mail(max_wait = settings.mail_pop3_timeout, keep_or_delete = :delete, &block)
    messages = []
    time_of_start = Time.now
    exception = nil
    while Time.now < time_of_start + max_wait
      begin
        exception = nil
        start do |pop_obj|
          pop_obj.mails.each do |mail|
            begin
              mail_message = Mail.new(mail.pop.to_s)
              if block_given?
                if block.call(mail_message)
                  if keep_or_delete == :delete
                    mail.delete
                    log.info "Mail '#{mail_message.subject}' deleted from #{@options[:pop3][:user_name]}"
                  end
                  messages << mail_message
                  @old_ids << mail.unique_id
                  return messages
                end
              else
                messages << mail_message
              end
            rescue Net::POPError => e
              log.warn "Exception in POP find_mail: #{e.message}"
              exception = e
            end
          end
        end

        sleep 5
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET, Net::POPAuthenticationError => e
        log.warn "Exception in POP find_mail: #{e.message}. Will retry."
        exception = e
      end
    end
    log.error exception unless exception.nil?
    messages
  end

  def send_mail(mail_from, mail_to, mail_subject, mail_body, mail_attachment=nil)
    log.info "Send emails with next parameters:\n " +
                 "mail_from : #{mail_from},\n mail_to : #{mail_to}\n " +
                 "mail_subject : #{mail_subject},\n has_attachment? : #{!mail_attachment.nil?}"
    outbound_mail = Mail.new do
      from(mail_from)
      subject(mail_subject)
      body(mail_body)
      add_file(mail_attachment) unless mail_attachment.nil?
    end
    outbound_mail[:to] = mail_to

    retryable(:on => [Errno::ETIMEDOUT, Timeout::Error], :sleep => 10, :tries => 3, :trace => true, :logger => log) do
      outbound_mail.deliver!
    end
  end

  def empty_inbox
    begin
      start {|pop_obj| pop_obj.delete_all }
      log.info "Email box (#{@options[:pop3][:user_name]}) was purged"
    rescue Net::POPError => e
      log.warn "Exception during deletion all messages from '#{@options[:pop3][:user_name]}':\n#{e.message}"
    end
  end

  def start(&block)
    retryable(:timeout => settings.mail_pop3_timeout, :sleep => 5, :trace => true, :logger => log) do
      Net::POP3.start(@options[:pop3][:address], @options[:pop3][:port],
                    @options[:pop3][:user_name], @options[:pop3][:password], &block)
    end
  end

  private
  def initialize(*arg)
    @options = self.class.merge_opts(*arg)
    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
    @old_ids = []
    options = @options
    ::Mail.defaults{delivery_method :smtp, options[:smtp]}
    @time_of_start = Time.now
  end

end
