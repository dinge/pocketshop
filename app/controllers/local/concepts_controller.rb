class Local::ConceptsController < ApplicationController
  helper :units
  before_filter :init_local_concept, :only => [:show, :edit, :update, :destroy]

  def index
    @local_local_concepts = Local::Concept.all.nodes.to_a
    if @local_local_concepts.empty?
      redirect_to new_local_concept_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @local_local_concepts }
        format.json { render :json => @local_local_concepts }
      end
    end
  end

  def new
    @local_concept = Local::Concept.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @local_concept }
      format.json { render :json => @local_concept }
    end
  end

  def create
    @local_concept = Local::Concept.new

    respond_to do |format|
      if @local_concept.update(params[:local_concept])
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_local_concept_path(@local_concept) }
        format.xml  { render :xml => @local_concept, :status => :created, :location => @local_concept }
        format.json { render :json => @local_concept, :status => :created, :location => @local_concept }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @local_concept.errors, :status => :unprocessable_entity }
        format.json { render :json => @local_concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @local_concept }
      format.json { render :json => @local_concept }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @local_concept.update(params[:local_concept])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_local_concept_path(@local_concept) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @local_concept.errors, :status => :unprocessable_entity }
        format.json { render :json => @local_concept.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @local_concept.delete
    respond_to do |format|
      format.html { redirect_to local_concept_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    Local::Concept.all.each do |local_concept|
      local_concept.delete
    end
    redirect_to local_concept_path
  end

  def playground
    
  end

  private

  def init_local_concept
    @local_concept = Local::Concept.load(params[:id])
    # Java::OrgNeo4jApiCore::NotFoundException
  end
end
