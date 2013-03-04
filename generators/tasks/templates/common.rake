desc "Check broken links"
task :check_links do
  require 'rawler'
  require 'active_support/core_ext'
  require 'howitzer/helpers'

  log.settings_as_formatted_text
  opts = {
      wait: 0.1,
      logfile: File.expand_path(settings.rawler_log, settings.log_dir)
  }
  opts[:username] = settings.app_base_auth_login unless settings.app_base_auth_login.blank?
  opts[:password] = settings.app_base_auth_pass unless settings.app_base_auth_pass.blank?
  Rawler::Base.new(app_base_url, $stdout, opts).validate
end
