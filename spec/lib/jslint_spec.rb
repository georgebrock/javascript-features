# -*- encoding : utf-8 -*-
require "simple_jshint"
describe "built in JavaScript" do
  it "passes JSHint" do
    path = File.join(File.dirname(__FILE__), '../../lib/assets/javascripts/javascript_features.js')
    File.open(path) { |file| SimpleJSHint.check(file.read).should be_ok }
  end
end
