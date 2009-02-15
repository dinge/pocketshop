class TagsController < ApplicationController
  helper :units
  before_filter :init_tag, :only => [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all.nodes.to_a
    if @tags.empty?
      redirect_to new_tag_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @tags }
        format.json { render :json => @tags }
      end
    end
  end

  def new
    @tag = Tag.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @tag }
      format.json { render :json => @tag }
    end
  end

  def create
    @tag = Tag.new
    my.creations << @tag

    respond_to do |format|
      if @tag.update(params[:tag])
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_tag_path(@tag) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
        format.json { render :json => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @tag }
      format.json { render :json => @tag }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tag.update(params[:tag])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_tag_path(@tag) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.delete
    respond_to do |format|
      format.html { redirect_to tags_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    Tag.all.each do |tag|
      tag.delete
    end
    redirect_to tags_path
  end


  private

  def init_tag
    @tag = Tag.load(params[:id])
  end


end
