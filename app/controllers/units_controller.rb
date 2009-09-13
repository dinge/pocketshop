class UnitsController < ApplicationController
  before_filter :init_concept, :only => [:show, :edit, :update, :destroy, :index, :create]
  before_filter :init_unit, :only => [:show, :edit, :update]

  def index
    @units = @concept.units.to_a
  end

  def show
  end

  def new
    # @unit = Unit.new
  end

  def create
    params_for_unit = params[:unit].first
    plan_klass = "Unit::Plan::#{params_for_unit[:type]}".constantize

    unit = Unit.new(params_for_unit)
    unit.created_at = Time.now
    unit.plan = plan_klass.new

    @concept.units << unit
    @concept.save
    redirect_to edit_concept_path(@concept)
  end

  def edit
  end

  def update
    @unit.attributes = params[:unit][@unit.id].except(:type)
    @concept.save
    redirect_to edit_concept_path(@concept)
  end

  def destroy
    @concept.units = @concept.units.reject{|unit| unit.name == params[:id]}
    @concept.save
    redirect_to edit_concept_path(@concept)
  end

  protected

  def init_concept
    @concept = Concept.find(params[:concept_id]) rescue raise(ActiveRecord::RecordNotFound)
  end

  def init_unit
    @unit = @concept.units.find{|unit| unit.name == params[:id]}
    raise ActiveRecord::RecordNotFound if @unit.blank?
  end

end
