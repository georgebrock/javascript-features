require 'rubygems'
require 'yaml'
require 'bundler'
Bundler.require(:default, :development)

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
