class CreateSubscriptionFuLogs < ActiveRecord::Migration
  def self.up
    create_table :subscription_fu_logs do |t|
      t.integer :user_id
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :subscription_fu_logs
  end
end
