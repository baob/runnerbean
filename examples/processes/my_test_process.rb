class MyTestProcess
  attr_accessor :group_name

  def start_command
    "echo 'This would be the start command, logging to prefix of #{group_name}' &&" \
    "echo '... with a following delay of #{sleep_after_start}'"
  end

  def sleep_after_start
    7
  end

  def kill_command
    "echo 'This would be the kill command, logging to prefix of #{group_name}' &&" \
    "echo '... with a following delay of #{sleep_after_kill}'"
  end

  def sleep_after_kill
    4
  end
end
