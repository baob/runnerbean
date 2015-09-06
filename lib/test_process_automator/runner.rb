module TestProcessAutomator
  class Runner
    attr_reader :name

    def initialize(opts = {})
      @name = opts[:name] || 'tpa_runner'
    end

    def add_process(opts)
      opts.each do |key, value|
        process_index[key] = value
      end
    end

    def kill!(*process_names)
      generic_command(:kill, *process_names)
    end

    def start!(*process_names)
      generic_command(:start, *process_names)
    end

    private

    def generic_command(command, *process_names)
      processes = processes_from_names(*process_names)

      request_log_files(*processes)

      commands = find_commands(command, *processes)
      execute(*commands)

      sleep_times = find_sleep_times(command, *processes)
      sleep_for(*sleep_times)
    end

    def sleep_for(*sleep_times)
      sleep(sleep_times.max) unless sleep_times.size == 0
    end

    def find_sleep_times(command, *processes)
      sleep_getter = "sleep_after_#{command}".to_sym
      processes.map(&sleep_getter).compact
    end

    def execute(*commands)
      commands.map { |k| system(k) } unless commands.size == 0
    end

    def find_commands(command, *processes)
      command_getter = "#{command}_command".to_sym
      processes.map(&command_getter).compact
    end

    def processes_from_names(*process_names)
      process_names.map { |pn| process_from_name(pn) }
    end

    def request_log_files(*processes)
      processes.each { |p| p.log_file_prefix = name }
    end

    def process_from_name(name)
      process_index.fetch(name)
    rescue KeyError => e
      raise ProcessNotDefined, e.message
    end

    def process_index
      @process_index ||= {}
    end
  end
end
