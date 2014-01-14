require 'sinatra' 
require 'sinatra/activerecord'
require './config/environments'
require 'json'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

# env_index = ARGV.index("-e")
# env_arg = ARGV[env_index + 1] if env_index
# env = env_arg || ENV["SINATRA_ENV"] || "development"

# use ActiveRecord::ConnectionAdapters::ConnectionManagement # close connection to the DDBB properly...https://github.com/puma/puma/issues/59
# databases = YAML.load_file("config/database.yml")
# ActiveRecord::Base.establish_connection(databases[env])

# if env == 'test'
#   User.destroy_all
# end


get '/' do
  erb :index
end

get '/find/:name.json' do
  @user_name = params[:name]
  streak = Streak.new(@user_name)
  @history = History.new(@user_name)
  content_type :json
  @user_data = {:username => @user_name}
  @user_data[:contributions_today] = streak.contributions_today
  @user_data[:current_streak] = streak.current_streak
  @user_data[:days_without_contributions] = streak.days_without_contributions
  com = streak.comparison_this_year
  @user_data[:days_this_year_with_contributions] = streak.days_this_year_with_contributions
  @user_data[:days_in_the_year] = com[:total_days]
  @user_data[:percentage_days_commited_this_year] = streak.percentage_commits_per_year(com)
  long_com = streak.comparison_years_time
  @user_data[:percentage_days_commited_known_history] = streak.percentage_commits_per_year(long_com)
  @user_data.to_json
end

get '/users/:name' do
  @user_name = params[:name]
  streak = Streak.new(@user_name)
  @history = History.new(@user_name)
  @today = streak.contributions_today
  @no_contributions = streak.days_without_contributions
  @current_streak = streak.current_streak
  com = streak.comparison_this_year
  @this_year_cont = streak.days_this_year_with_contributions
  @days = com[:total_days]
  @percentage = streak.percentage_commits_per_year(com)
  @signed_up = @history.user_created_date
  long_com = streak.comparison_years_time
  @long_percentage = streak.percentage_commits_per_year(long_com)
  erb :streak
end

get "/all" do
  @count = User.all.count
  @users = User.all
  @params = params
  erb :count
end

get "/register" do
  erb :register
end

#call from the terminal to access
#curl --data "github_username=rrgayhart" http://localhost:4567/register
post "/register" do
    @user = User.new(:github_username => params[:github_username])
    @user.save
  redirect '/all'
end


