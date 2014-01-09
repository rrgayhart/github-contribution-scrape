class AddGithubStartdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_start, :datetime
  end
end
