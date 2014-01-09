class AddContributionHistoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contribution_history, :string, array: true, default: '{}'
  end
end
