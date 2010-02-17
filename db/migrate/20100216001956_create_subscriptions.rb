class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :product_id
      t.boolean :active, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
