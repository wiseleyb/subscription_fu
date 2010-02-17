class Subscription < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :product
  
  #this processes a subscription order and throws errors suitable for catching and flash[error]'ing by the controller
  # TODO throw custom errors for easier testing
  def self.process_order(order)
    #wrap this all in a transaction to avoid have bits and pieces lying around after failure (thar be many pitfalls in auth.net land)
#    Subscription.transaction do
      errmsg = ""
#      begin
        sub = order.new_subscription 
        if order.valid? #double check - this should have been taken care of in the controller
          user = User.find_by_id(order.user_id)
          product = Product.find_by_id(order.product_id)
          unless user.cim_profile 
            user.cim_profile = CimProfile.create(order)
            user.save
          end
          order.user.cim_profile.auth_capture(product.price, product.id)
        else
          errmsg = order.errors.full_messages.join("; ")
          raise ActiveRecord::Rollback
        end
        sub.save!
        return sub
    #   rescue => e
    #     errmsg = e.message
    #     raise ActiveRecord::Rollback
    #   rescue ActiveRecord::Rollback
    #     raise errmsg and return unless errmsg.blank?
    #     raise "Unknown error"
    #   end #begin
    # end #transaction
    
  end


end


