class CreateCimProfiles < ActiveRecord::Migration
  def self.up
    create_table :cim_profiles do |t|
      t.integer :user_id
      t.string :transaction_key
      t.string :last_four
      t.integer :failed_payment_attempts, :default => 0
      t.string  :payment_profile_id
      t.string :first_name
      t.string :last_name
      t.integer :expiration_month
      t.integer :expiration_year

      t.timestamps
    end
  end

  def self.down
    drop_table :cim_profiles
  end
end
