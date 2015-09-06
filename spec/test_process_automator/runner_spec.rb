require 'test_process_automator'
require 'test_process_automator/runner'

module TestProcessAutomator
  RSpec.describe Runner do
    let(:runner) { described_class.new(init_options) }
    let(:init_options) { { name: name } }
    let(:the_frontend) { double('the frontend') }
    let(:the_worker) { double('the worker') }
    let(:a_process_group) { double('a process group') }

    describe 'initalised with a name' do
      let(:name) { 'a_name' }

      describe '#name' do
        specify { expect(runner.name).to be(name) }
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
        end
      end
    end
  end
end
