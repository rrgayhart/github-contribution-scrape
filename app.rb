require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'json'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

def valid_user?(username)
  url = "https://github.com/#{username}"
  response = Faraday.get(url)
  response.status == 200
end

get '/' do
  erb :index
end

get '/find/:name.json' do
  if valid_user?(params[:name])
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
    @user_data[:commits_this_year] = streak.commits_this_year
    @user_data.to_json
  else
    content_type :json
    @user_data = {:error => "INVALID USERNAME"}
    @user_data.to_json
  end
end

get '/users/:name' do
  @user_name = params[:name]
  if valid_user?(@user_name)
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
  else
    erb :error
  end
end

get "/all" do
  @count = User.all.count
  @users = User.all
  @params = params
  erb :count
end


#We want to store the commits from the very first date in the array
#(the day that is about to be lost from github) - combine old array with the github new array
#do calculations on this
#Work in Progress

# get "/register" do
#   erb :register
# end

# #call from the terminal to access
# #curl --data "github_username=rrgayhart" http://localhost:4567/register
# post "/register" do
#     @user = User.new(:github_username => params[:github_username])
#     @user.save
#   redirect '/all'
# end



