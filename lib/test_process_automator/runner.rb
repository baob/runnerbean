module TestProcessAutomator
  class Runner
    attr_reader :name

    def initialize(opts = {})
      @name = opts[:name] || 'tpa_runner'
    end
  end
end
