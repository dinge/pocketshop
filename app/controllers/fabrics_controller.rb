class FabricsController < ApplicationController

  def index
    @fabrics = Fabric.find(:all)
    @fabrics_array = @fabrics.to_a
  end

  def new
    @fabric = Fabric.new
  end

  def create
    @fabric = Fabric.create(params[:fabric])
    redirect_to edit_fabric_path(@fabric)
  end

  def show
    @fabric = Fabric.find(params[:id])
  end

  def edit
    @fabric = Fabric.find(params[:id])
  end

  def update
    @fabric = Fabric.find(params[:id])
    @fabric.update_attributes(params[:fabric])
    redirect_to edit_fabric_path(@fabric)
  end

  def destroy
    @fabric = Fabric.find(params[:id])
    @fabric.destroy
    redirect_to fabrics_path
  end

end
