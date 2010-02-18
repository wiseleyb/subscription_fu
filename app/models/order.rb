class Order  < ActiveRecord::Base
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :number
  
  belongs_to :user
  belongs_to :product
  
  before_save :dont_save
  
  def credit_card
    cc = ActiveMerchant::Billing::CreditCard.new
    cc.first_name = self.first_name
    cc.last_name = self.last_name
    cc.number = self.number
    cc.month = self.month
    cc.year = self.year
    cc.require_verification_value = false
    cc.type = ActiveMerchant::Billing::CreditCard.type?(cc.number)
    return cc
  end
  
  protected
  # TODO add configuration to allow custom selection of what types of cards are accepted
  def validate
    cc  = self.credit_card
    cc.validate
    cc.errors.full_messages.each do |e|
      self.errors.add_to_base(e)
    end
  end
  
  private
  def dont_save
    raise "This is only here for convenience - this should NEVER be saved to the database"
  end
  
end
