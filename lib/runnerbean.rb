require 'runnerbean/version'
require 'runnerbean/runner'

module Runnerbean
  def self.runner(name = 'runnerbean')
    Runnerbean::Runner.new(name: name)
  end

  class ProcessNotDefined < Exception; end
end
