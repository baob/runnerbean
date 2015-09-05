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
      processes = process_names.map { |pn| process_from_name(pn) }
      delegated_command = "#{command}_command".to_sym
      commands = processes.map(&delegated_command).compact
      commands.map { |k| system(k) } unless commands.size == 0
    end

    def process_from_name(name)
      process_index.fetch(name)
    end

    def process_index
      @process_index ||= {}
    end
  end
end
