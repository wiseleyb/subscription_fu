class CreateOrder < ActiveRecord::Migration

  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.integer :product_id
      t.string  :number
      t.integer :month
      t.integer :year
      t.string  :type
      t.string  :first_name
      t.string  :last_name
      t.string  :verification_value
    end
  end

  def self.down
    drop_table :orders
  end
  
end
