class CimPayment < ActiveRecord::Base
  
  belongs_to :cim_profile
  belongs_to :user
  belongs_to :product
  
  
  def product_name
    product.nil? ? "" : product.name
  end
  
end
