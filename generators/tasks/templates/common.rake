# Put here any common rake tasks
require 'howitzer/gmail_api/client'

desc 'Provides url to authorize application for gmail API usage'
task :'gmail-init' do
  Howitzer::GmailApi::Client.new
end
