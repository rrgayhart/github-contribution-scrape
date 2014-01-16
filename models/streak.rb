require 'faraday'
require 'json'
require 'pry'

class Streak

  attr_reader :user
  attr_accessor :user_array

  def initialize(username)
    @user = username
    @user_array = get_contributions_array(contribution_link)
  end

  def get_contributions
    get_contributions_array(contribution_link)
  end

  def contribution_link
    "https://github.com/users/#{user}/contributions_calendar_data"
  end

  def get_contributions_array(url)
      response = Faraday.get(url)
      JSON.parse(response.body)
  end

  def contribution_array_today
    @user_array.last
  end

  def contributions_today
    @user_array.last.last
  end

  def contributions_yesterday
    @user_array[-2].last
  end

  def current_streak
    array = @user_array.dup
    today = array.pop
    current = 0
    current += 1 if today.last != 0
    yesterday = array.pop
    if yesterday.last != 0
      current += 1
      array.count.times do
        day = array.pop
        if day.last != 0
          current += 1
        else
          break
        end
      end
    end
    current
  end

  def days_without_contributions
    dates = @user_array.select do |date|
      date.last < 1
    end
    dates.count
  end

  def days_with_contributions
    dates = @user_array.select do |date|
      date.last >= 1
    end
    dates.count
  end

  def select_recent_dates(num)
    @user_array.reverse.take(num)
  end

  def year(default=nil)
    default ||= Date.today.year
  end

  def commits_this_year
    dates = @user_array.select do |date|
      date.last > 1 && date.first.include?(year.to_s)
    end
    dates.inject(0) {|sum, date| sum + date.last }
  end

  def days_this_year_without_contributions
    dates = @user_array.select do |date|
      date.last < 1 && date.first.include?(year.to_s)
    end
    dates.count
  end

  def days_this_year_with_contributions
    dates = @user_array.select do |date|
      date.last >= 1 && date.first.include?(year.to_s)
    end
    dates.count
  end

  def comparison_this_year
    comparisons = {}
    comparisons[:total_days] = Date.today.yday
    comparisons[:contributions] = days_this_year_with_contributions
    comparisons
  end

  def comparison_years_time
    comparisons = {}
    comparisons[:total_days] = @user_array.length
    comparisons[:contributions] = days_with_contributions
    comparisons
  end

  def percentage_commits_per_year(comparison)
    a = comparison[:contributions]
    b = comparison[:total_days]
    a/b.round(2)
  end

  def array_since_joining(history)
    history = History.new(self.user)
    #start_date = history.user_created_date
  end
end
