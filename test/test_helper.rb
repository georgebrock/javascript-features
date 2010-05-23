require 'shoulda'
require 'redgreen' unless ENV["TM_PID"]
require 'webrick'
require 'active_support'

require 'javascript_features'

class Test::Unit::TestCase
  attr_accessor :request, :response
end

module Rails
  def self.root
    File.join(File.dirname(__FILE__), 'fixtures')
  end

  def self.backtrace_cleaner
    ActiveSupport::BacktraceCleaner.new
  end
end
