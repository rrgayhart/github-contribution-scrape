require 'sinatra' 
require 'sinatra/activerecord'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"

use ActiveRecord::ConnectionAdapters::ConnectionManagement # close connection to the DDBB properly...https://github.com/puma/puma/issues/59
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])

if env == 'test'
  User.destroy_all
end


get '/' do
  erb :index
end

get '/:name' do
  @user_name = params[:name]
  streak = Streak.new(@user_name)
  @history = History.new(@user_name)
  @today = streak.contributions_today
  @no_contributions = streak.days_without_contributions
  @current_streak = streak.current_streak
  com = streak.comparison_this_year
  @this_year = streak.days_this_year_with_contributions
  @days = com[:total_days]
  @percentage = streak.percentage_commits_per_year(com)
  @signed_up = @history.user_created_date
  long_com = streak.comparison_years_time
  @long_percentage = streak.percentage_commits_per_year(long_com)
  erb :streak
end



