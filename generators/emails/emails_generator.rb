require_relative '../base_generator'

module Howitzer
  # This class combines application email example generator methods
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
