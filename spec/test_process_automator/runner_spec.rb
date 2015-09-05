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

    context 'and with a :frontend process injected' do
      let(:the_frontend) { double('the frontend') }
      before do
        automator.add_process(frontend: the_frontend)
      end

      describe '#kill!(:frontend)' do
        subject { automator.kill!(:frontend) }
        let(:the_kill_command) { 'kill_that_frontend' }

        it 'runs shell command specified for frontend' do
          allow(the_frontend).to receive(:kill_command).and_return(the_kill_command)
          expect(automator).to receive(:system).with(the_kill_command)
          subject
        end
      end
    end
  end
end
