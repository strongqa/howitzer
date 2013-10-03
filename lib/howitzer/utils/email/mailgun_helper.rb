module MailgunHelper

  def create_mailbox(user_name,
                     domain=settings.mail_pop3_domain,
                     password=settings.mail_pop3_user_pass)
    log.info "Create '#{user_name}@#{domain}' mailbox"
    mbox = Mailbox.new(:user => user_name, :domain => domain, :password => password)
    mbox.upsert()
    mbox
  end

  def delete_mailbox(mailbox)
    log.info "Delete '#{mailbox.user}@#{mailbox.domain}' mailbox"
    begin
      Mailbox.remove(mailbox)
    rescue Exception => e
      log.warn "Unable to delete '#{mailbox.user}' mailbox: #{e.message}"
    end
  end

  def delete_all_mailboxes(*exceptions)
    exceptions += ["postmaster@#{settings.mail_smtp_domain}"] #system and default mailbox
    exceptions = exceptions.uniq
    log.info "Delete all mailboxes except: #{exceptions.map(&:inspect).join(', ')}"
    i = 0
    Mailbox.find(:all).each do |m|
      next if exceptions.include?("#{m.user}@#{m.domain}")
      Mailbox.delete(m.id)
      i += 1
    end

    log.info "Were deleted '#{i}' mailboxes"
  end
end