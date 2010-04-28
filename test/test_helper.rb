require 'shoulda'
require 'redgreen' unless ENV["TM_PID"]

require 'javascript_features'

module Rails
  def self.root
    File.join(File.dirname(__FILE__), 'fixtures')
  end
end
