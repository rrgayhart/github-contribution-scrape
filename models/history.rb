require 'faraday'
require 'json'

class History

  attr_reader :user
  attr_accessor :user_hash

  def initialize(username)
    @user = username
    @user_hash = user_detail_hash(user_link)
  end

  def user_link
    "https://api.github.com/users/#{user}"
  end

  def user_detail_hash(url)
    response = Faraday.get(url)
    body = JSON.parse(response.body)
  end

  def user_created_date
    user_hash["created_at"].to_date
  end

  def new_user?
    days_since = Date.today - user_created_date
    days_since < 366
  end

end
