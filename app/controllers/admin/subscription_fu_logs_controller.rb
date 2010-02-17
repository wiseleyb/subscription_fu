class Admin::SubscriptionFuLogsController < ApplicationController
  # GET /subscription_fu_logs
  # GET /subscription_fu_logs.xml
  def index
    @subscription_fu_logs = SubscriptionFuLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscription_fu_logs }
    end
  end

  # GET /subscription_fu_logs/1
  # GET /subscription_fu_logs/1.xml
  def show
    @subscription_fu_log = SubscriptionFuLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscription_fu_log }
    end
  end

  # GET /subscription_fu_logs/new
  # GET /subscription_fu_logs/new.xml
  def new
    @subscription_fu_log = SubscriptionFuLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscription_fu_log }
    end
  end

  # GET /subscription_fu_logs/1/edit
  def edit
    @subscription_fu_log = SubscriptionFuLog.find(params[:id])
  end

  # POST /subscription_fu_logs
  # POST /subscription_fu_logs.xml
  def create
    @subscription_fu_log = SubscriptionFuLog.new(params[:subscription_fu_log])

    respond_to do |format|
      if @subscription_fu_log.save
        flash[:notice] = 'SubscriptionFuLog was successfully created.'
        format.html { redirect_to(@subscription_fu_log) }
        format.xml  { render :xml => @subscription_fu_log, :status => :created, :location => @subscription_fu_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription_fu_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subscription_fu_logs/1
  # PUT /subscription_fu_logs/1.xml
  def update
    @subscription_fu_log = SubscriptionFuLog.find(params[:id])

    respond_to do |format|
      if @subscription_fu_log.update_attributes(params[:subscription_fu_log])
        flash[:notice] = 'SubscriptionFuLog was successfully updated.'
        format.html { redirect_to(@subscription_fu_log) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subscription_fu_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscription_fu_logs/1
  # DELETE /subscription_fu_logs/1.xml
  def destroy
    @subscription_fu_log = SubscriptionFuLog.find(params[:id])
    @subscription_fu_log.destroy

    respond_to do |format|
      format.html { redirect_to(subscription_fu_logs_url) }
      format.xml  { head :ok }
    end
  end
end
