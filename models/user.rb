class User < ActiveRecord::Base
  validates_presence_of :github_username
  validates_uniqueness_of :github_username

  def contribution_url
    username = self.github_username
    contribution_link(username)
  end

  def add_user_start_date
    unless self.github_start
      history = History.new(self.github_username)
      self.github_start = history.user_created_date
    end
  end

  def add_user_contribution_history
    
  end


  #store the array of 366 days
  #from then on, just add the latest day to that array

end
