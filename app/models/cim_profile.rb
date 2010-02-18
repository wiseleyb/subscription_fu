require 'money'

class CimProfile < ActiveRecord::Base
  
  belongs_to :user
  has_many :cim_payments
  
  # TODO needs to be moved to a config area
  FAILURE_ATTEMPTS = 3  #this is how many times the system will retry billing before abandoning this cim profile
  
  def gateway
    CimProfile.gateway
  end
  def self.gateway
    CIMGATEWAY
  end
  
  def self.create(order)

    payment = {
      :credit_card => order.credit_card
    }
    payment_profile = {
      :customer_type => 'individual',
      :bill_to => {},
      :payment => payment
    }

    merchant_customer_id = order.user.login.gsub(/[^.-_0-9A-Z a-z]/,'').slice(0,20)

    # we do this to avoid duplicate cim profiles with test data
    unless RAILS_ENV == 'production'
      merchant_customer_id = merchant_customer_id.slice(0,12) + rand.to_s.slice(2,8)
    end

    profile = {
      :merchant_customer_id => merchant_customer_id,
      :email => order.user.email,
      :payment_profiles => payment_profile
    }
    opt = {
      :profile => profile
    }

    # please don't lose response.authorization.   There is no way to retrieve it!
    response = gateway.create_customer_profile(opt)
    #puts response
    unless response.success?
      raise StandardError, "#{response.message}"
    end
    cp = CimProfile.new
    credit_card = order.credit_card
    cp.transaction_key = response.authorization
    cp.last_four = credit_card.last_digits
    cp.expiration_month = credit_card.month.to_i
    cp.expiration_year = credit_card.year.to_i
    cp.first_name = order.first_name
    cp.last_name = order.last_name
    cp.user_id = order.user_id
    
    customer_profile_response = gateway.get_customer_profile :customer_profile_id => response.authorization
    if customer_profile_response.success?
      cp.payment_profile_id = customer_profile_response.params['profile']['payment_profiles']['customer_payment_profile_id']
    else
      raise StandardError, "Unable to locate payment_profile_id"
    end
    
    cp.save
    SubscriptionFuLog.create!(:user_id => cp.user.id, 
          :note => "Created CimProfile id-#{cp.id}")
    return cp
  end


  # expects amount in BigDecimal which represents dollar amount.
  def auth_capture(product, subscription)
    amount = product.price
    product_id = product.id
    amount = BigDecimal.new(amount.to_s) unless amount.is_a? BigDecimal
    amount = Money.new amount * 100

    res = get_profile_transaction_hash(amount)
    response = create_customer_profile_transaction(res)

    unless response && response.success?
      self.failed_payment_attempts += 1
      self.save
      # TODO make failed payment attempts configurable
      if self.failed_payment_attempts >= 3
        subscription.active = false
        subscription.save
        # TODO - there should be some kind of notification going on here
        SubscriptionFuLog.create!(:user_id => self.user.id, 
              :note => "Canceled subscription for #{self.user.login} for sub-id #{subscription.id} with an end date #{subscription.end_date.to_s(:db)}")
      else
        SubscriptionFuLog.create!(:user_id => self.user.id, 
              :note => "Failed capturing funds.  authorize.net CIM response: #{response.message}.  Attempt ##{self.failed_payment_attempts}")
      end
      self.save
      subject = "Failure capturing funds.  #{response.message}"
      raise StandardError, subject
    end
    self.failed_payment_attempts = 0
    self.save
    cim_payment = CimPayment.create!(
      :user_id => self.user_id,
      :amount => amount.cents / 100.0,
      :cim_profile => self,
      :product_id => product_id,
      :transaction_key => response.params['direct_response']['transaction_id']
    )
    SubscriptionFuLog.create!(:user_id => self.user_id, 
          :note => "Billed user #{cim_payment.amount}")
    return cim_payment
  end

  def get_profile_transaction_hash(amount)
    logger.info("Charging user #{self.user.login} #{amount.to_s} via profile #{self.transaction_key}")
    trans = {
      :customer_profile_id => self.transaction_key,
      :customer_payment_profile_id => self.payment_profile_id,
      :type => :auth_capture,
      :amount => amount
    }
    return {:transaction => trans}
  end
  
  def create_customer_profile_transaction(options)
    return gateway.create_customer_profile_transaction(options)
  end
  
end
