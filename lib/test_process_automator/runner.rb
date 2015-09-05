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
      processes = process_names.map { |pn| process_from_name(pn) }
      kills = processes.map(&:kill_command).compact
      kills.map { |k| system(k) } unless kills.size == 0
    end

    private

    def process_from_name(name)
      process_index.fetch(name)
    end

    def process_index
      @process_index ||= {}
    end
  end
end
