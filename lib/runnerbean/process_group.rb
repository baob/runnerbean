module Runnerbean
  class ProcessGroup
    attr_reader :processes
    attr_writer :name

    def initialize(*processes)
      @processes = processes
    end

    def kill!
      generic_command(:kill)
    end

    def start!
      generic_command(:start)
    end

    def name
      @name ||= default_process_group_name
    end

    def ensure_started!
      kill_if_running!
      start!
    end

    private

    def default_process_group_name
      return processes.map(&:name).join('_and_')
    rescue
      'default_process_group_name'
    end

    def generic_command(command)
      set_group_name_on_processes

      commands = find_commands(command)
      execute(*commands)

      sleep_times = find_sleep_times(command)
      sleep_for(*sleep_times)
    end

    def set_group_name_on_processes
      processes.each { |p| p.group_name = name }
    end

    def kill_if_running!
      running_processes = processes.select(&:running?)
      kill_group = self.class.new(*running_processes)
      kill_group.kill!
    end

    def find_commands(command)
      command_getter = "#{command}_command".to_sym
      processes.map(&command_getter).compact
    end

    def execute(*commands)
      commands.map { |k| Kernel.system(k) } unless commands.size == 0
    end

    def find_sleep_times(command)
      sleep_getter = "sleep_after_#{command}".to_sym
      processes.map(&sleep_getter).compact
    end

    def sleep_for(*sleep_times)
      Kernel.sleep(sleep_times.max) unless sleep_times.size == 0
    end
  end
end
