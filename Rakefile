require "sinatra/activerecord/rake"
require 'rake/testtask'
require "./app"

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = false
end
