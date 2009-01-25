class Sys::UsersController < ApplicationController

  before_filter :init_user, :only => [:show, :edit, :update, :destroy]

  def index
    @sys_users = Sys::User.all.nodes.to_a
    if @sys_users.empty?
      redirect_to new_sys_user_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @sys_users }
        format.json { render :json => @sys_users }
      end
    end
  end

  def new
    @sys_user = Sys::User.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @sys_user }
      format.json { render :json => @sys_user }
    end
  end

  def create
    @sys_user = Sys::User.new

    respond_to do |format|
      if @sys_user.update(params[:sys_user])
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_sys_user_path(@sys_user) }
        format.xml  { render :xml => @sys_user, :status => :created, :location => @sys_user }
        format.json { render :json => @sys_user, :status => :created, :location => @sys_user }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @sys_user.errors, :status => :unprocessable_entity }
        format.json { render :json => @sys_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @sys_user }
      format.json { render :json => @sys_user }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sys_user.update(params[:sys_user])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_sys_user_path(@sys_user) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @sys_user.errors, :status => :unprocessable_entity }
        format.json { render :json => @sys_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @sys_user.delete
    respond_to do |format|
      format.html { redirect_to sys_users_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    Sys::User.all.each do |user|
      user.delete
    end
    redirect_to sys_users_path
  end


  private

  def init_user
    @sys_user = Sys::User.load(params[:id])
    # Java::OrgNeo4jApiCore::NotFoundException
  end

end
