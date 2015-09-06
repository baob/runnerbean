require 'runnerbean/version'
require 'runnerbean/runner'

module TestProcessAutomator
  def self.tpa_runner(name = 'tpa_runner')
    TestProcessAutomator::Runner.new(name: name)
  end

  class ProcessNotDefined < Exception; end
end
