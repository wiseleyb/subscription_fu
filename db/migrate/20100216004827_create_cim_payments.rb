class CreateCimPayments < ActiveRecord::Migration
  def self.up
    create_table :cim_payments do |t|
      t.integer :user_id
      t.integer :cim_profile_id
      t.integer :product_id
      t.integer :transaction_key
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :cim_payments
  end
end
