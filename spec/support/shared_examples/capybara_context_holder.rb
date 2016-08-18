require 'spec_helper'

RSpec.shared_examples :capybara_context_holder do
  describe '#capybara_context' do
    let(:web_page_class) do
      klass = described_class
      Class.new do
        include klass
      end
    end
    subject { web_page_class.new.capybara_context }
    context 'when parent class has the method' do
      before do
        web_page_class.class_eval do
          def capybara_context
            true
          end
        end
      end
      it 'should execute parent method' do
        is_expected.to eq(true)
      end
    end
    context 'when parent class does not have the method' do
      it 'should raise error' do
        expect { subject }.to raise_error(
          NotImplementedError,
          "Please define 'capybara_context' method for class holder"
        )
      end
    end
  end
end
