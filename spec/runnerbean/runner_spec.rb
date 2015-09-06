require 'runnerbean'
require 'runnerbean/runner'

module TestProcessAutomator
  RSpec.describe Runner do
    let(:runner) { described_class.new(init_options) }
    let(:init_options) { { name: the_runner_name } }
    let(:the_frontend) { double('the frontend') }
    let(:the_worker) { double('the worker') }
    let(:a_process_group) { double('a process group', :'name=' => nil) }

    describe 'initalised with a name' do
      let(:the_runner_name) { 'a_name' }

      describe '#name' do
        specify { expect(runner.name).to be(the_runner_name) }
      end

      context 'with a :frontend process injected' do
        before { runner.add_process(frontend: the_frontend) }

        context 'and with a :worker process injected' do
          before { runner.add_process(worker: the_worker) }

          describe '#group(:worker)' do
            subject { runner.group(:worker) }

            it 'returns process_group initialised with worker' do
              expect(ProcessGroup).to receive(:new).with(the_worker).and_return(a_process_group)
              expect(subject).to be(a_process_group)
            end
          end

          describe '#group(:worker, :frontend)' do
            subject { runner.group(:worker, :frontend) }

            it 'returns process_group initialised with worker and frontend' do
              expect(ProcessGroup).to receive(:new).with(the_worker, the_frontend).and_return(a_process_group)
              expect(subject).to be(a_process_group)
            end
          end

          describe '#start!(:frontend)' do
            subject { runner.start!(:frontend) }
            before do
              allow(a_process_group).to receive(:start!)
              allow(ProcessGroup).to receive(:new).with(the_frontend).and_return(a_process_group)
            end

            it 'returns process_group initialised with frontend' do
              expect(ProcessGroup).to receive(:new).with(the_frontend).and_return(a_process_group)
              expect(subject).to be(a_process_group)
            end

            it 'calls .start! on the process group' do
              expect(a_process_group).to receive(:start!)
              subject
            end
          end

          describe '#kill!(:worker)' do
            subject { runner.kill!(:worker) }
            before do
              allow(a_process_group).to receive(:kill!)
              allow(ProcessGroup).to receive(:new).with(the_worker).and_return(a_process_group)
            end

            it 'returns process_group initialised with worker' do
              expect(ProcessGroup).to receive(:new).with(the_worker).and_return(a_process_group)
              expect(subject).to be(a_process_group)
            end

            it 'calls .kill! on the process group' do
              expect(a_process_group).to receive(:kill!)
              subject
            end
          end

          describe '#start!(:backend)' do
            subject { runner.start!(:backend) }

            it 'raises not defined exception' do
              expect { subject }.to raise_error(::TestProcessAutomator::ProcessNotDefined)
            end
          end
        end
      end
    end
  end
end
