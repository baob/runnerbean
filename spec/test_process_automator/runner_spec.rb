require 'test_process_automator/runner'

RSpec.describe TestProcessAutomator::Runner do
  let(:automator) { described_class.new(init_options) }
  let(:init_options) { { name: name } }

  describe 'initalised with a name' do
    let(:name) { double('a name') }

    describe '#name' do
      subject { automator.name }

      specify { expect(subject).to be(name) }
    end
  end
end
