require 'runnerbean'
require 'runnerbean/runner'

RSpec.describe Runnerbean do
  describe '.tpa_runner' do
    subject { described_class.tpa_runner }

    specify { expect(subject).to be_instance_of(Runnerbean::Runner) }
  end
end
