require 'test_process_automator'
require 'test_process_automator/runner'

RSpec.describe TestProcessAutomator::Runner do
  let(:runner) { described_class.new(init_options) }
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
      subject { runner.name }

      specify { expect(subject).to be(name) }
    end

    context 'and with a :frontend process injected' do
      before { runner.add_process(frontend: the_frontend) }

      describe '#kill!(:frontend)' do
        subject { runner.kill!(:frontend) }

        it 'runs shell command specified for frontend' do
          expect(runner).to receive(:system).with(the_frontend_kill)
          subject
        end
      end

      describe '#start!(:frontend)' do
        subject { runner.start!(:frontend) }

        it 'runs shell command specified for frontend' do
          expect(runner).to receive(:system).with(the_frontend_start)
          subject
        end
      end

      describe '#start!(:backend)' do
        subject { runner.start!(:backend) }

        it 'raises not defined exception' do
          expect { subject }.to raise_error(::TestProcessAutomator::ProcessNotDefined)
        end
      end

      context 'and with a :worker process injected' do
        before { runner.add_process(worker: the_worker) }

        describe '#kill!(:worker)' do
          subject { runner.kill!(:worker) }

          it 'runs shell command specified for worker' do
            expect(runner).to receive(:system).with(the_worker_kill)
            subject
          end

          it 'does not runs shell command specified for frontend' do
            expect(runner).to_not receive(:system).with(the_frontend_kill)
            subject
          end
        end

        describe '#kill!(:worker, :frontend)' do
          subject { runner.kill!(:worker, :frontend) }
          before { allow(runner).to receive(:system).with(anything) }

          it 'runs shell command specified for worker' do
            expect(runner).to receive(:system).with(the_worker_kill)
            subject
          end

          it 'runs shell command specified for frontend' do
            expect(runner).to receive(:system).with(the_frontend_kill)
            subject
          end
        end
      end # context 'and with a :worker process injected' do
    end # context 'and with a :frontend process injected' do
  end
end
