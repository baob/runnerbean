require 'runnerbean'
require 'runnerbean/runner'

module TestProcessAutomator
  RSpec.describe Runner do
    let(:runner) { described_class.new(init_options) }
    let(:init_options) { { name: name } }
    let(:name) { 'a_name' }
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

    describe 'integration with process groups' do
      context 'with a :frontend process injected' do
        before { runner.add_process(frontend: the_frontend) }

        describe '#kill!(:frontend)' do
          subject { runner.kill!(:frontend) }

          it 'runs shell command specified for frontend' do
            expect(Kernel).to receive(:system).with(the_frontend_kill)
            subject
          end
        end

        describe '#start!(:frontend)' do
          subject { runner.start!(:frontend) }

          it 'runs shell command specified for frontend' do
            expect(Kernel).to receive(:system).with(the_frontend_start)
            subject
          end
        end

        context 'with a :worker process injected' do
          before { runner.add_process(worker: the_worker) }

          describe '#kill!(:worker)' do
            subject { runner.kill!(:worker) }

            it 'runs shell command specified for worker' do
              expect(Kernel).to receive(:system).with(the_worker_kill)
              subject
            end

            it 'does not runs shell command specified for frontend' do
              expect(Kernel).to_not receive(:system).with(the_frontend_kill)
              subject
            end
          end

          describe '#kill!(:worker, :frontend)' do
            subject { runner.kill!(:worker, :frontend) }

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
end
