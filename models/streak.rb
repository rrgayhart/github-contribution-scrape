require 'faraday'
require 'json'

class Streak

  def contribution_link(username)
    "https://github.com/users/#{username}/contributions_calendar_data"
  end

  def get_contributions_array(url, stub=nil)
    unless stub
      response = Faraday.get(url)
      body = JSON.parse(response.body)
    else
      body = stub
    end
    body
  end

  def contributions_today(url, stub=nil)
    body = get_contributions_array(url, stub)
    body.last.last
  end

  def contributions_yesterday(url, stub=nil)
    body = get_contributions_array(url, stub)
    body[-2].last
  end

  def current_streak(url, stub=nil)
    array = get_contributions_array(url, stub)
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

  def days_without_contributions(url)
    body = get_contributions_array(url)
    dates = body.select do |date|
      date.last < 1
    end
    dates.count
  end

  def year(default=nil)
    default ||= Date.today.year
  end

  def days_this_year_without_contributions(url, y=nil)
    body = get_contributions_array(url)
    year = Date.today.year.to_s
    dates = body.select do |date|
      date.last < 1 && date.first.include?(year(y))
    end
    dates.count
  end

  def days_in_the_year_with_contributions(url, y=nil)
    body = get_contributions_array(url)
    dates = body.select do |date|
      date.last >= 1 && date.first.include?(year(y).to_s)
    end
    dates.count
  end

  def comparison(url, y=nil)
    comparisons = {}
    if y && y.to_s != Date.today.yday
      comparisons[:total_days] = 365
    else
      comparisons[:total_days] = Date.today.yday
    end
    comparisons[:contributions] = days_in_the_year_with_contributions(url, y)
    comparisons
  end

  def percentage_commits_per_year(comparison)
    a = comparison[:contributions]
    b = comparison[:total_days]
    a/b.round(2)
  end
end
