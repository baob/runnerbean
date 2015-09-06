require 'runnerbean'
require 'runnerbean/runner'

RSpec.describe Runnerbean do
  describe '.runner' do
    subject { described_class.runner }

    specify { expect(subject).to be_instance_of(Runnerbean::Runner) }
  end
end
