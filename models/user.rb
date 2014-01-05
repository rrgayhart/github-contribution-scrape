require 'faraday'
require 'json'

class User < ActiveRecord::Base
  validates_presence_of :email

  def contribution_url
    username = self.github_username
    contribution_link(username)
  end

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

  def days_this_year_without_contributions(url)
    body = get_contributions_array(url)
    year = Date.today.year.to_s
    dates = body.select do |date|
      date.last < 1 && date.first.include?(year)
    end
    dates.count
  end

  def days_in_the_year_with_contributions(url)
    body = get_contributions_array(url)
    year = Date.today.year.to_s
    dates = body.select do |date|
      date.last >= 1 && date.first.include?(year)
    end
    dates.count
  end

  def comparisons(url)
    comparisons = {}
    comparisons[:total_days] = Date.today.yday
    comparisons[:contributions] = days_in_the_year_with_contributions(url)
    comparisons
  end

  def percentage_commits_this_year(url)
    a = comparisons(url)[:contributions]
    b = comparisons(url)[:total_days]
    a/b.round(2)
  end

end
