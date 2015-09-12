class Frontend
  attr_accessor :group_name

  def start_command
    "echo 'This would be the Frontend start command'"
  end

  def sleep_after_start
    1
  end

  def kill_command
    "echo 'This would be the Frontend kill command'"
  end

  def sleep_after_kill
    1
  end

  def running?
    true
  end
end
