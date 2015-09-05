require 'test_process_automator/version'
require 'test_process_automator/runner'

module TestProcessAutomator
  def self.tpa_runner
    TestProcessAutomator::Runner.new
  end

  class ProcessNotDefined < Exception; end
end
