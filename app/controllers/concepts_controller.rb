class ConceptsController < ApplicationController
  helper :units
  before_filter :init_concept, :only => [:show, :edit, :update, :destroy]

  def index
    @concepts = Concept.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @concepts }
      format.json { render :json => @concepts }
    end
  end

  def new
    @concept = Concept.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @concept }
      format.json { render :json => @concept }
    end
  end

  def create
    @concept = Concept.new(params[:concept])

    respond_to do |format|
      if @concept.save
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_concept_path(@concept) }
        format.xml  { render :xml => @concept, :status => :created, :location => @concept }
        format.json { render :json => @concept, :status => :created, :location => @concept }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @concept.errors, :status => :unprocessable_entity }
        format.json { render :json => @concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @concept }
      format.json { render :json => @concept }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @concept.update_attributes(params[:concept])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_concept_path(@concept) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @concept.errors, :status => :unprocessable_entity }
        format.json { render :json => @concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @concept.destroy
    respond_to do |format|
      format.html { redirect_to concepts_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def playground
    
  end

  private

  def init_concept
    @concept = Concept.find(params[:id]) rescue raise(ActiveRecord::RecordNotFound)
  end
end
