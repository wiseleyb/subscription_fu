class SubscriptionsController < ApplicationController


  def new
    @order = Order.new
    @order.user_id = params[:user_id]
    @order.first_name = "Bob"
    @order.last_name = "Jones"
    @order.number = "4012888888881881"
    @order.product_id = 1
  end
  
  def create
    
    @order = Order.new(params[:order])
    if @order.valid?
#      begin
        sub = Subscription.process_order(@order)
        flash[:notice] = "Thank you for your subscription!"
        redirect_to subscription_path(sub) and return
      # rescue => e
      #   flash[:error] = e.message
      #   render :action => "new" and return
      # end
    else
      render :action => "new" and return
    end
    
  end

  def show
    @subscription = Subscription.find params[:id]
  end
  
end
