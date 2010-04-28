require "rubygems"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

task :default => ["test"]

task :gem do
  exec 'gem build javascript_features.gemspec'
end
