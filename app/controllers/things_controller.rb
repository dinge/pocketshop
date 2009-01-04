class ThingsController < ApplicationController

  # before_filter :init_thing, :only => [:show, :edit, :update, :destroy]

  def index
    Thing.delete_all
    @thing = Thing.new(:name => 'fass', :age => rand(10))
    @thing.save

    @things = Thing.find(:all)#.to_a
    respond_to do |format|
      format.html
      format.xml  { render :xml => @things }
      format.json { render :json => @things }
    end
  end

  def new
    @thing = Thing.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @thing }
      format.json { render :json => @thing }
    end
  end

  def create
    @thing = Thing.new(params[:thing])

    respond_to do |format|
      if @thing.save
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_thing_path(@thing) }
        format.xml  { render :xml => @thing, :status => :created, :location => @thing }
        format.json { render :json => @thing, :status => :created, :location => @thing }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @thing.errors, :status => :unprocessable_entity }
        format.json { render :json => @thing.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    # thing = Thing.new('kamel')
    # # thing.save
    # thing.save
    
    @thing = Thing.find('kamel')


    respond_to do |format|
      format.html
      format.xml  { render :xml => @thing }
      format.json { render :json => @thing }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @thing.update_attributes(params[:thing])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_thing_path(@thing) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @thing.errors, :status => :unprocessable_entity }
        format.json { render :json => @thing.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @thing.destroy
    respond_to do |format|
      format.html { redirect_to things_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  private

  def init_thing
    @thing = Thing.find(params[:id])# rescue raise(ActiveRecord::RecordNotFound)
  end

end
