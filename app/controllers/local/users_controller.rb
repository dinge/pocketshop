class Local::UsersController < ApplicationController

  before_filter :init_local_user, :only => [:show, :edit, :update, :destroy]

  def index
    @local_users = Local::User.all.nodes.to_a
    if @local_users.empty?
      redirect_to new_local_user_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @local_users }
        format.json { render :json => @local_users }
      end
    end
  end

  def new
    @local_user = Local::User.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @local_user }
      format.json { render :json => @local_user }
    end
  end

  def create
    @local_user = Local::User.new

    respond_to do |format|
      if @local_user.update(params[:local_user])
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_local_user_path(@local_user) }
        format.xml  { render :xml => @local_user, :status => :created, :location => @local_user }
        format.json { render :json => @local_user, :status => :created, :location => @local_user }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @local_user.errors, :status => :unprocessable_entity }
        format.json { render :json => @local_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @local_user }
      format.json { render :json => @local_user }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @local_user.update(params[:local_user])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_local_user_path(@local_user) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @local_user.errors, :status => :unprocessable_entity }
        format.json { render :json => @local_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @local_user.delete
    respond_to do |format|
      format.html { redirect_to local_users_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    Local::User.all.each do |user|
      user.delete
    end
    redirect_to local_users_path
  end


  private

  def init_local_user
    @local_user = Local::User.load(params[:id])
    # Java::OrgNeo4jApiCore::NotFoundException
  end

end
