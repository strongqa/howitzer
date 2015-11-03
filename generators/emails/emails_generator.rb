require_relative '../base_generator'

module Howitzer
  # This class responsible for email examples generation
  class EmailsGenerator < BaseGenerator
    def manifest
      { files: [source: 'example_email.rb', destination: '/emails/example_email.rb'] }
    end

    protected

    def banner
      <<-EOS
  * Email example generation ...
      EOS
    end
  end
end
