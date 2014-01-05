require 'faraday'
require 'json'

class Streak

  def contribution_link(username)
    "https://github.com/users/#{username}/contributions_calendar_data"
  end

  def get_contributions_array(url)
    response = Faraday.get(url)
    JSON.parse(response.body)
  end

  def contributions_today(url)
    body = get_contributions_array(url)
    body.last.last
  end

  def days_without_contributions(url)
    body = get_contributions_array(url)
    dates = body.select do |date|
      date.last < 1
    end
    dates.count
  end

  def year(default=nil)
    if default
      return default
    else
      Date.today.year
    end
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

  def comparisons(url, y=nil)
    comparisons = {}
    if y && y.to_s != Date.today.yday
      comparisons[:total_days] = 365
    else
      comparisons[:total_days] = Date.today.yday
    end
    comparisons[:contributions] = days_in_the_year_with_contributions(url, y)
    comparisons
  end

  def percentage_commits_this_year(url)
    a = comparisons(url)[:contributions]
    b = comparisons(url)[:total_days]
    a/b.round(2)
  end

  def percentage_commits_per_year(url, year)
    a = comparisons(url, year)[:contributions]
    b = comparisons(url, year)[:total_days]
    a/b.round(2)
  end
end
