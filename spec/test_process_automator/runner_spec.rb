require 'test_process_automator/runner'

RSpec.describe TestProcessAutomator::Runner do
  let(:automator) { described_class.new(init_options) }
  let(:init_options) { { name: name } }

  describe 'initalised with a name' do
    let(:name) { 'a_name' }

    describe '#name' do
      subject { automator.name }

      specify { expect(subject).to be(name) }
    end

    context 'and with a :frontend process injected' do
      let(:the_frontend_kill_command) { 'kill_that_frontend' }
      let(:the_frontend) do
        double('the frontend',
               kill_command: the_frontend_kill_command
              )
      end
      before do
        automator.add_process(frontend: the_frontend)
      end

      describe '#kill!(:frontend)' do
        subject { automator.kill!(:frontend) }

        it 'runs shell command specified for frontend' do
          expect(automator).to receive(:system).with(the_frontend_kill_command)
          subject
        end
      end

      context 'and with a :worker process injected' do
        let(:the_worker_kill_command) { 'kill_that_worker' }
        let(:the_worker) do
          double('the worker',
                 kill_command: the_worker_kill_command
                )
        end
        before do
          automator.add_process(worker: the_worker)
        end

        describe '#kill!(:worker)' do
          subject { automator.kill!(:worker) }

          it 'runs shell command specified for worker' do
            expect(automator).to receive(:system).with(the_worker_kill_command)
            subject
          end

          it 'does not runs shell command specified for frontend' do
            expect(automator).to_not receive(:system).with(the_frontend_kill_command)
            subject
          end
        end

        describe '#kill!(:worker, :frontend)' do
          subject { automator.kill!(:worker, :frontend) }
          before { allow(automator).to receive(:system).with(anything) }

          it 'runs shell command specified for worker' do
            expect(automator).to receive(:system).with(the_worker_kill_command)
            subject
          end

          it 'runs shell command specified for frontend' do
            expect(automator).to receive(:system).with(the_frontend_kill_command)
            subject
          end
        end
      end
    end
  end
end
