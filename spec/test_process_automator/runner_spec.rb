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
           start_command: the_frontend_start,
           sleep_after_start: 7,
           sleep_after_kill: 2,
           :'log_file_prefix=' => nil
          )
  end
  let(:the_worker_kill) { 'kill_that_worker' }
  let(:the_worker) do
    double('the worker',
           kill_command: the_worker_kill,
           sleep_after_kill: 4,
           :'log_file_prefix=' => nil
          )
  end
  before { allow(runner).to receive(:system).with(anything) }
  before { allow(runner).to receive(:sleep).with(anything) }

  describe 'initalised with a name' do
    let(:name) { 'a_name' }

    describe '#name' do
      subject { runner.name }

      specify { expect(subject).to be(name) }
    end

    context 'and with an incomplete process defined' do
      let(:bad_process) do
        class BadProcess; end
        BadProcess
      end
      before { runner.add_process(bad_process: bad_process) }

      describe '#start!(:bad_process)' do
        subject { runner.start!(:bad_process) }

        it 'raises no method error' do
          expect { subject }.to raise_error(NoMethodError)
        end
      end
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

        it 'instructs process to log to logfile' do
          expect(the_frontend).to receive(:log_file_prefix=).with(name)
          subject
        end

        it 'sleeps for specified time' do
          expect(runner).to receive(:sleep).with(the_frontend.sleep_after_start)
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
