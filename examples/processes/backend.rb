class Backend
  attr_accessor :group_name

  def start_command
    "echo 'This would be the Backend start command'"
  end

  def sleep_after_start
    1
  end

  def kill_command
    "echo 'This would be the Backend kill command'"
  end

  def sleep_after_kill
    1
  end
end
