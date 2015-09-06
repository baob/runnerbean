require 'runnerbean/version'
require 'runnerbean/runner'

module Runnerbean
  def self.tpa_runner(name = 'tpa_runner')
    Runnerbean::Runner.new(name: name)
  end

  class ProcessNotDefined < Exception; end
end
