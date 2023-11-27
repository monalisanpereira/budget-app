class BudgetsController < ApplicationController
  before_action :require_user
  
  def new
    return redirect_to root_path, alert: t('alerts.errors.budget_create') unless params[:family_id].present?

    family = Family.find(params[:family_id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_editor?(current_user)

    @budget = Budget.new(family: family)
    @members = family.members
    @budget_assignees = @members.map { |member| @budget.budget_assignees.build(user: member) }
  end
  
  def create
    return redirect_to root_path, alert:  t('alerts.errors.budget_create') unless params[:family_id].present?

    family = Family.find(budget_params[:family_id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_editor?(current_user)

    @budget = Budget.new(budget_params)
  
    if @budget.save
      redirect_to budget_path(@budget)
    else
      redirect_to new_budget_path(family_id: @budget.family.id), alert:  t('alerts.errors.budget_create')
    end
  end

  def edit
    @budget = Budget.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @budget.family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless @budget.family.member_is_above_editor?(current_user)

    @budget_assignees = @budget.family.members.map { |member| @budget.budget_assignees.where(user: member).present? ? @budget.budget_assignees.where(user: member) : @budget.budget_assignees.build(user: member) }
  end

  def update
    @budget = Budget.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @budget.family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless @budget.family.member_is_above_editor?(current_user)

    if @budget.update(budget_params)
      redirect_to budget_path(@budget)
    else
      redirect_to new_budget_path(family_id: @budget.family.id), alert:  t('alerts.errors.budget_update')
    end
  end

  def destroy
    @budget = Budget.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @budget.family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless @budget.family.member_is_above_editor?(current_user)
    
    family = @budget.family
    @budget.destroy

    redirect_to family_path(family)
  end

  def show
    @budget = Budget.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @budget.family.members.include?(current_user)
    
    @period = params[:period] || @budget.current_period
    @period_range = @budget.period_range(@period)
    @expenditures = @budget.expenditures.in_period(@period_range)
  end
  
  private
    def budget_params
      params.require(:budget).permit(:name, :amount, :family_id, :period, budget_assignees_attributes: [:id, :user_id, :percentage])
    end
end
