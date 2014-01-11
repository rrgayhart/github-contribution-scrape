require "sinatra/activerecord/rake"
require 'rake/testtask'
require "./app"

task :default => :test
env = ENV["RACK_ENV"] || "development"

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = false
end
