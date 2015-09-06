require 'test_process_automator'
require 'test_process_automator/process_group'

module TestProcessAutomator
  RSpec.describe ProcessGroup do
    let(:group) { described_class.new(*processes) }
    let(:name) { 'default_process_group_name' }
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
    before { allow(Kernel).to receive(:system).with(anything) }
    before { allow(Kernel).to receive(:sleep).with(anything) }

    context 'with an incomplete process defined' do
      let(:bad_process) do
        class BadProcess; end
        BadProcess
      end
      let(:processes) { [bad_process] }

      describe '#start!' do
        subject { group.start! }

        it 'raises no method error' do
          expect { subject }.to raise_error(NoMethodError)
        end
      end
    end

    context 'with a :frontend process injected' do
      let(:processes) { [the_frontend] }

      describe '#kill!' do
        subject { group.kill! }

        it 'runs shell command specified for frontend' do
          expect(Kernel).to receive(:system).with(the_frontend_kill)
          subject
        end

        it 'sleeps for specified time' do
          expect(Kernel).to receive(:sleep).with(the_frontend.sleep_after_kill)
          subject
        end
      end

      describe '#start!' do
        subject { group.start! }

        it 'runs shell command specified for frontend' do
          expect(Kernel).to receive(:system).with(the_frontend_start)
          subject
        end

        it 'instructs process to log to logfile' do
          expect(the_frontend).to receive(:log_file_prefix=).with(name)
          subject
        end

        it 'sleeps for specified time' do
          expect(Kernel).to receive(:sleep).with(the_frontend.sleep_after_start)
          subject
        end
      end

      context 'with a :worker process injected' do
        let(:processes) { [the_frontend, the_worker] }

        describe '#kill!' do
          subject { group.kill! }

          it 'runs shell command specified for worker' do
            expect(Kernel).to receive(:system).with(the_worker_kill)
            subject
          end

          it 'runs shell command specified for frontend' do
            expect(Kernel).to receive(:system).with(the_frontend_kill)
            subject
          end
        end
      end # context 'with a :worker process injected' do
    end # context 'with a :frontend process injected' do
  end
end
