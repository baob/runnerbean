require 'runnerbean'
require 'runnerbean/process_group'

module Runnerbean
  RSpec.describe ProcessGroup do
    let(:group) { described_class.new(*processes) }
    let(:name) { 'default_process_group_name' }
    let(:the_frontend_kill) { 'kill_that_frontend' }
    let(:the_frontend_start) { 'start_that_frontend' }
    let(:the_frontend) do
      double('the frontend',
             name: 'name_of_the_frontend',
             kill_command: the_frontend_kill,
             start_command: the_frontend_start,
             sleep_after_start: 7,
             sleep_after_kill: 2,
             :'group_name=' => nil
            )
    end
    let(:the_worker_kill) { 'kill_that_worker' }
    let(:the_worker) do
      double('the worker',
             name: 'name_of_the_worker',
             kill_command: the_worker_kill,
             sleep_after_kill: 4,
             :'group_name=' => nil
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

      describe '#name' do
        specify { expect(group.name).to eq(the_frontend.name) }
      end

      describe '#kill!' do
        subject { group.kill! }

        it_behaves_like 'frontend killer'
      end

      describe '#start!' do
        subject { group.start! }

        it_behaves_like 'frontend starter'
      end

      describe '#ensure_started!' do
        subject { group.ensure_started! }

        context 'when process is not running' do
          before { allow(the_frontend).to receive(:running?).and_return(false) }

          it 'does not runs kill shell command specified for frontend' do
            expect(Kernel).to_not receive(:system).with(the_frontend_kill)
            subject
          end

          it_behaves_like 'frontend starter'
        end

        context 'when process is already running' do
          before { allow(the_frontend).to receive(:running?).and_return(true) }

          it_behaves_like 'frontend killer'
          it_behaves_like 'frontend starter'
        end
      end

      context 'with a :worker process injected' do
        let(:processes) { [the_frontend, the_worker] }

        describe '#name' do
          let(:expected_name) { [the_frontend.name, the_worker.name].join('_and_') }

          specify { expect(group.name).to eq(expected_name) }
        end

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

        context 'and with the name overridden' do
          describe '#name' do
            let(:new_name) { 'override_name' }
            before { group.name = new_name }

            specify { expect(group.name).to eq(new_name) }
          end
        end
      end # context 'with a :worker process injected' do
    end # context 'with a :frontend process injected' do
  end
end
