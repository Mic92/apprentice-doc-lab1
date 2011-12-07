class AddPwExpiredAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pw_expired_at, :timestamp
  end
end
