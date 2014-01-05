require 'sinatra' 
require 'sinatra/activerecord'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }



  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension

  get '/' do
    "Add your github username after the slash in the address to get your stats"
  end

  get '/:name' do
     user_name = params[:name]
     streak = Streak.new
     url = streak.contribution_link(user_name)
     c = streak.contributions_today(url)
     d = streak.days_without_contributions(url)
     "#{user_name} has made #{c} contribution(s) today. In the past 366 days, #{user_name} has had #{d} day(s) without any contributions."
  end



