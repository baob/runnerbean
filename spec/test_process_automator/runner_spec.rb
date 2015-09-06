require 'test_process_automator'
require 'test_process_automator/runner'

module TestProcessAutomator
  RSpec.describe Runner do
    let(:runner) { described_class.new(init_options) }
    let(:init_options) { { name: name } }

    describe 'initalised with a name' do
      let(:name) { 'a_name' }

      describe '#name' do
        subject { runner.name }

        specify { expect(subject).to be(name) }
      end
    end
  end
end
