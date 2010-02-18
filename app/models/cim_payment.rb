class CimPayment < ActiveRecord::Base
  
  belongs_to :cim_profile
  belongs_to :user
  belongs_to :product
  
  
  def product_name
    res = ""
    if product
      res << product.product_category.name
      res << ":" 
      res << product.name
    end
    return res
  end
  
end
