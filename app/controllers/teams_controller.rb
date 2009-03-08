class TeamsController < ApplicationController

  before_filter :init_team, :only => [:show, :edit, :update, :destroy]

  def index
    @teams = Team.all.nodes.to_a
    if @teams.empty?
      redirect_to new_team_path
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @teams }
        format.json { render :json => @teams }
      end
    end
  end

  def new
    @team = Team.value_object.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @team }
      format.json { render :json => @team }
    end
  end

  def create
    Neo4j::Transaction.run do
      @team = Team.new
      @team.update(params[:team])
    end

    respond_to do |format|
      if @team.valid?
        flash[:notice] = 'successfully created.'
        format.html { redirect_to edit_team_path(@team) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
        format.json { render :json => @team, :status => :created, :location => @team }
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
        format.json { render :json => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @team }
      format.json { render :json => @team }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @team.update(params[:team])
        flash[:notice] = 'successfully updated.'
        format.html { redirect_to edit_team_path(@team) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
        format.json { render :json => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.delete
    respond_to do |format|
      format.html { redirect_to teams_path }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  def delete_all
    Team.all.each do |team|
      team.delete
    end
    redirect_to teams_path
  end


  private

  def init_team
    @team = Team.load(params[:id])
  end
end
