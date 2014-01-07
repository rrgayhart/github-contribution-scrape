require 'faraday'
require 'json'

class History

  def user_link(username)
    "https://api.github.com/users/#{username}"
  end

  def user_detail_hash(url)
    response = Faraday.get(url)
    body = JSON.parse(response.body)
  end

  def user_created_date(user_hash)
    user_hash["created_at"].to_date
  end

end
