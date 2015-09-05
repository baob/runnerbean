require 'test_process_automator'
require 'test_process_automator/runner'

RSpec.describe TestProcessAutomator::Runner do
  let(:automator) { described_class.new(init_options) }
  let(:init_options) { { name: name } }
  let(:the_frontend_kill) { 'kill_that_frontend' }
  let(:the_frontend_start) { 'start_that_frontend' }
  let(:the_frontend) do
    double('the frontend',
           kill_command: the_frontend_kill,
           start_command: the_frontend_start
          )
  end
  let(:the_worker_kill) { 'kill_that_worker' }
  let(:the_worker) do
    double('the worker',
           kill_command: the_worker_kill
          )
  end

  describe 'initalised with a name' do
    let(:name) { 'a_name' }

    describe '#name' do
      subject { automator.name }

      specify { expect(subject).to be(name) }
    end

    context 'and with a :frontend process injected' do
      before { automator.add_process(frontend: the_frontend) }

      describe '#kill!(:frontend)' do
        subject { automator.kill!(:frontend) }

        it 'runs shell command specified for frontend' do
          expect(automator).to receive(:system).with(the_frontend_kill)
          subject
        end
      end

      describe '#start!(:frontend)' do
        subject { automator.start!(:frontend) }

        it 'runs shell command specified for frontend' do
          expect(automator).to receive(:system).with(the_frontend_start)
          subject
        end
      end

      describe '#start!(:backend)' do
        subject { automator.start!(:backend) }

        it 'raises not defined exception' do
          expect { subject }.to raise_error(::TestProcessAutomator::ProcessNotDefined)
        end
      end

      context 'and with a :worker process injected' do
        before { automator.add_process(worker: the_worker) }

        describe '#kill!(:worker)' do
          subject { automator.kill!(:worker) }

          it 'runs shell command specified for worker' do
            expect(automator).to receive(:system).with(the_worker_kill)
            subject
          end

          it 'does not runs shell command specified for frontend' do
            expect(automator).to_not receive(:system).with(the_frontend_kill)
            subject
          end
        end

        describe '#kill!(:worker, :frontend)' do
          subject { automator.kill!(:worker, :frontend) }
          before { allow(automator).to receive(:system).with(anything) }

          it 'runs shell command specified for worker' do
            expect(automator).to receive(:system).with(the_worker_kill)
            subject
          end

          it 'runs shell command specified for frontend' do
            expect(automator).to receive(:system).with(the_frontend_kill)
            subject
          end
        end
      end # context 'and with a :worker process injected' do
    end # context 'and with a :frontend process injected' do
  end
end
