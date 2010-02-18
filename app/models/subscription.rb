class Subscription < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :product
  belongs_to :product_category
  
  named_scope :active, :conditions => {:active => true}
  named_scope :recurring, :conditions => {:recurring => true}
  named_scope :user_id, lambda { |uid| { :conditions => { :user_id => uid }}}
  named_scope :product_category_id, lambda { |pcid| { :conditions => { :product_category_id => pcid }}}

  # TODO - lame - can't use CimProfile.FAILURE_ATTEMPTS ... hard coded 3 for now
  named_scope :date_window, lambda { |d| 
    {
      :conditions => "start_date >= #{d.to_s(:db)} and end_date <= #{(d + 3).to_s(:db)}"
    }}
  default_scope :order => "end_date desc"
  
  #this processes a subscription order and throws errors suitable for catching and flash[error]'ing by the controller
  # TODO throw custom errors for easier testing
  def self.process_order(order)
    #wrap this all in a transaction to avoid have bits and pieces lying around after failure (thar be many pitfalls in auth.net land)
#    Subscription.transaction do
      errmsg = ""
#      begin
        oldsub, newsub = Subscription.from_order(order)
        if order.valid? #double check - this should have been taken care of in the controller
          user = User.find_by_id(order.user_id)
          product = Product.find_by_id(order.product_id)
          unless user.cim_profile 
            user.cim_profile = CimProfile.create(order)
            user.save
          end
          cp = user.cim_profile
          cp.auth_capture(product, oldsub) # will throw an error if it fails
          newsub.active = true
          newsub.save
          return newsub
        else
          errmsg = order.errors.full_messages.join("; ")
          raise ActiveRecord::Rollback
        end
    #   rescue => e
    #     errmsg = e.message
    #     raise ActiveRecord::Rollback
    #   rescue ActiveRecord::Rollback
    #     raise errmsg and return unless errmsg.blank?
    #     raise "Unknown error"
    #   end #begin
    # end #transaction
    
  end

  #return the old subscription, new subscription.  If old sub doesn't exist then it returns nil, new sub
  def self.from_order(order)
    #does the user have an active, recurring subscription?
    user = order.user
    prod = order.product
    prod_cat = prod.product_category
    oldsub = Subscription.last_active_recurring_subscription(user.id, prod_cat.id)
    newsub = Subscription.new(:user_id => user.id,
                :product_id => prod.id,
                :product_category_id => prod_cat.id,
                :active => false,
                :recurring => prod.recurring)
    if oldsub.nil?
      newsub.start_date = Date.today
    else
      newsub.start_date = oldsub.end_date + 1
    end
    newsub.end_date = newsub.start_date + prod.duration.months
    return oldsub, newsub
  end

  #find the last active subscription - do this to add more time to someone with one or more subscriptions
  def self.last_active_recurring_subscription(user_id, prod_cat_id)
    Subscription.active.recurring.user_id(user_id).product_category_id(prod_cat_id).first
  end
  
  #find a users subscritption that is active now
  def self.current_active_recurring_subscription(user_id, prod_cat_id, d = Date.today)
    Subscription.active.recurring.user_id(user_id).product_category_id(prod_cat_id).date_window(d).first
  end
  
  # this should be run by some cron type application, nightly 
  # this finds all subscriptions for users who
  # => have a current subscription past it's end date that's still active and recurring
  # => don't have another subscription in the queue
  # => TODO - I'm not sure if this handles people with gaps in their subscriptions yet
  def self.nightly_billing(d = Date.today)
    raise "todo"
  end
  
  # this deactives subscriptions that have expired - should be run nightly from cron
  def self.cancel_subscriptions(d = Date.today)
    d += CimProfile::FAILURE_ATTEMPTS
    #typically you'd build in room for credit card failures by adding a few days to this check (see failed_payment_attempts cim_profile.auth_capture)
    Subscription.update_all("active = false, end_date < #{d.to_s(:db)}")
  end

end


