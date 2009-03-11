class ThingsController < ApplicationController

  before_filter :init_thing, :only => [:show, :edit, :update, :destroy]

  before_filter :creatable?, :only => [:new, :create]
  before_filter :visible?, :only => :show
  before_filter :changeable?, :only => [:edit, :update]
  before_filter :destroyable?, :only => :destroy

  def index
    @things = my.created_things

    respond_to do |format|
      format.html
      format.xml  { render :xml => @things }
      format.json { render :json => @things }
    end
  end

  def new
    @thing = Thing.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @thing }
      format.json { render :json => @thing }
    end
  end

  def create
    Neo4j::Transaction.run do
      @thing = Thing.new
      @thing.update(params[:thing])
      my.created_things << @thing
    end

    respond_to do |format|
      if @thing.valid?
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
      if @thing.update(params[:thing])
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
    @thing.delete
    respond_to do |format|
      format.html { redirect_to things_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  private

  def init_thing
    @thing = Thing.load(params[:id])
  end




  def creatable?
    unless Thing.creatable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def visible?
    unless @thing.visible_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def changeable?
    unless @thing.changeable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

  def destroyable?
    unless @thing.destroyable_for?(Me.now)
      flash[:error] = "access forbidden"
      redirect_to root_path
    end
  end

end
