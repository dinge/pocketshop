class UsersController < ApplicationController

  before_filter :init_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all.nodes.to_a
    if @users.empty?
      redirect_to new_user_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @users }
        format.json { render :json => @users }
      end
    end
  end

  def new
    @user = User.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
      format.json { render :json => @user }
    end
  end

  def create
    Neo4j::Transaction.run do
      @user = User.new
      @user.update(params[:user])
    end

    respond_to do |format|
      if @user.valid?
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_user_path(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
      format.json { render :json => @user }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(params[:user])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_user_path(@user) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.delete
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    User.all.each do |user|
      user.delete
    end
    redirect_to users_path
  end


  private

  def init_user
    @user = User.load(params[:id])
    # Java::OrgNeo4jApiCore::NotFoundException
  end

end
