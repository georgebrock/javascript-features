require File.join(File.dirname(__FILE__), *%w[test_helper])
require 'jslint'

class JslintTest < Test::Unit::TestCase

  context 'all built-in JavaScript' do
    should 'pass JSLint' do
      paths = File.join(File.dirname(__FILE__), '../assets/**/*.js')
      exclude = File.join(File.dirname(__FILE__), '../assets/jquery.js')
      JSLint::Lint.new(:paths => paths, :exclude_paths => exclude).run
    end
  end

end
