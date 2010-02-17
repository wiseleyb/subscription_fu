class Admin::CimProfilesController < ApplicationController
  # GET /cim_profiles
  # GET /cim_profiles.xml
  def index
    @cim_profiles = CimProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cim_profiles }
    end
  end

  # GET /cim_profiles/1
  # GET /cim_profiles/1.xml
  def show
    @cim_profile = CimProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cim_profile }
    end
  end

  # GET /cim_profiles/new
  # GET /cim_profiles/new.xml
  def new
    @cim_profile = CimProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cim_profile }
    end
  end

  # GET /cim_profiles/1/edit
  def edit
    @cim_profile = CimProfile.find(params[:id])
  end

  # POST /cim_profiles
  # POST /cim_profiles.xml
  def create
    @cim_profile = CimProfile.new(params[:cim_profile])

    respond_to do |format|
      if @cim_profile.save
        flash[:notice] = 'CimProfile was successfully created.'
        format.html { redirect_to(@cim_profile) }
        format.xml  { render :xml => @cim_profile, :status => :created, :location => @cim_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_profiles/1
  # PUT /cim_profiles/1.xml
  def update
    @cim_profile = CimProfile.find(params[:id])

    respond_to do |format|
      if @cim_profile.update_attributes(params[:cim_profile])
        flash[:notice] = 'CimProfile was successfully updated.'
        format.html { redirect_to(@cim_profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cim_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_profiles/1
  # DELETE /cim_profiles/1.xml
  def destroy
    @cim_profile = CimProfile.find(params[:id])
    @cim_profile.destroy

    respond_to do |format|
      format.html { redirect_to(cim_profiles_url) }
      format.xml  { head :ok }
    end
  end
end
