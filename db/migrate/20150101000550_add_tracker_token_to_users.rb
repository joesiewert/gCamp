class AddTrackerTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tracker_token, :string
  end
end
