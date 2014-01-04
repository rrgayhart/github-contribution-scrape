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
end
