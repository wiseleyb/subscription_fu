class Admin::CimPaymentsController < ApplicationController
  # GET /cim_payments
  # GET /cim_payments.xml
  def index
    @cim_payments = CimPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cim_payments }
    end
  end

  # GET /cim_payments/1
  # GET /cim_payments/1.xml
  def show
    @cim_payment = CimPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cim_payment }
    end
  end

  # GET /cim_payments/new
  # GET /cim_payments/new.xml
  def new
    @cim_payment = CimPayment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cim_payment }
    end
  end

  # GET /cim_payments/1/edit
  def edit
    @cim_payment = CimPayment.find(params[:id])
  end

  # POST /cim_payments
  # POST /cim_payments.xml
  def create
    @cim_payment = CimPayment.new(params[:cim_payment])

    respond_to do |format|
      if @cim_payment.save
        flash[:notice] = 'CimPayment was successfully created.'
        format.html { redirect_to(@cim_payment) }
        format.xml  { render :xml => @cim_payment, :status => :created, :location => @cim_payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_payments/1
  # PUT /cim_payments/1.xml
  def update
    @cim_payment = CimPayment.find(params[:id])

    respond_to do |format|
      if @cim_payment.update_attributes(params[:cim_payment])
        flash[:notice] = 'CimPayment was successfully updated.'
        format.html { redirect_to(@cim_payment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cim_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_payments/1
  # DELETE /cim_payments/1.xml
  def destroy
    @cim_payment = CimPayment.find(params[:id])
    @cim_payment.destroy

    respond_to do |format|
      format.html { redirect_to(cim_payments_url) }
      format.xml  { head :ok }
    end
  end
end
