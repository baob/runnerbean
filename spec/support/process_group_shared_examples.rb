shared_examples_for 'frontend starter' do
  it 'runs shell start command specified for frontend' do
    expect(Kernel).to receive(:system).with(the_frontend.start_command)
    subject
  end

  it 'instructs process to log to logfile, prefixed with group name' do
    expect(the_frontend).to receive(:group_name=).with(group.name)
    subject
  end

  it 'sleeps for specified time after start' do
    expect(Kernel).to receive(:sleep).with(the_frontend.sleep_after_start)
    subject
  end
end

shared_examples_for 'frontend killer' do
  it 'runs kill shell command specified for frontend' do
    expect(Kernel).to receive(:system).with(the_frontend.kill_command)
    subject
  end

  it 'sleeps for specified time after kill' do
    expect(Kernel).to receive(:sleep).with(the_frontend.sleep_after_kill)
    subject
  end
end
