require 'sinatra' 
require 'sinatra/activerecord'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

class GitApp < Sinatra::Base
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension
end

