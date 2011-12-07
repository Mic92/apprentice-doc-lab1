class AddPwRecoveryHashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pw_recovery_hash, :string
  end
end
