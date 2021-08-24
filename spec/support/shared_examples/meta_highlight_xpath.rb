RSpec.shared_examples :meta_highlight_xpath do
  let(:element) { described_class.new(name, context) }
  describe '#xpath' do
    let(:capybara_element) { double }
    context 'when element is found' do
      before { allow(element).to receive(:capybara_element) { capybara_element } }
      it do
        expect(capybara_element).to receive(:path)
        element.xpath
      end
    end
    context 'when element is blank' do
      before { allow(element).to receive(:capybara_element) { nil } }
      it do
        expect(capybara_element).not_to receive(:path)
        element.xpath
      end
    end
  end

  describe '#highlight' do
    context 'when xpath blank' do
      before { allow(element).to receive(:xpath) { nil } }
      it do
        expect(Howitzer::Log).to receive(:debug).with("Element #{name} not found on the page")
        expect(context).not_to receive(:execute_script)
        element.highlight
      end
    end
    context 'when xpath is present' do
      before { allow(element).to receive(:xpath) { '//a' } }
      it do
        expect(context).to receive(:execute_script).with(
          "document.evaluate('//a', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE,"\
          ' null).singleNodeValue.style.border = "thick solid red"'
        )
        element.highlight
      end
    end
  end
end
