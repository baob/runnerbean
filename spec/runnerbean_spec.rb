require 'test_process_automator'
require 'test_process_automator/runner'

RSpec.describe TestProcessAutomator do
  describe '.tpa_runner' do
    subject { described_class.tpa_runner }

    specify { expect(subject).to be_instance_of(TestProcessAutomator::Runner) }
  end
end
