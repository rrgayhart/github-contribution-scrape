class User < ActiveRecord::Base
  validates_presence_of :email

  def contribution_url
    username = self.github_username
    contribution_link(username)
  end

end
