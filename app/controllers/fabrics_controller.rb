class FabricsController < ApplicationController
  before_filter :init_fabric, :only => [:show, :edit, :update, :destroy]

  def index
    @fabrics = Fabric.find(:all).to_a

    respond_to do |format|
      format.html
      format.xml  { render :xml => @fabrics }
      format.json { render :json => @fabrics }
    end
  end

  def new
    @fabric = Fabric.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @fabric }
      format.json { render :json => @fabric }
    end
  end

  def create
    @fabric = Fabric.new(params[:fabric])

    respond_to do |format|
      if @fabric.save
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_fabric_path(@fabric) }
        format.xml  { render :xml => @fabric, :status => :created, :location => @fabric }
        format.json { render :json => @fabric, :status => :created, :location => @fabric }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @fabric.errors, :status => :unprocessable_entity }
        format.json { render :json => @fabric.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @fabric }
      format.json { render :json => @fabric }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @fabric.update_attributes(params[:fabric])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_fabric_path(@fabric) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @fabric.errors, :status => :unprocessable_entity }
        format.json { render :json => @fabric.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @fabric.destroy
    respond_to do |format|
      format.html { redirect_to fabrics_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end


  private

  def init_fabric
    @fabric = Fabric.find(params[:id])
  end
end
