include DataGenerator
include Capybara::DSL #TODO should be included to webpage instead of global content

# Configure mail client
Mailgun::init(settings.mailgun_api_key)