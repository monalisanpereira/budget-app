class BudgetsController < ApplicationController
  def new
    return redirect_to root_path unless params[:family_id].present?

    family = Family.find(params[:family_id])
    @budget = Budget.new(family: family)
    @members = family.members
    @budget_assignees = @members.map { |member| @budget.budget_assignees.build(user: member) }
  end
  
  def create
    @budget = Budget.new(budget_params)
  
    if @budget.save
      redirect_to family_path(@budget.family)
    else
      flash[:alert] = @budget.errors
      redirect_to new_budget_path(family_id: @budget.family.id)
    end
  end

  def edit
    @budget = Budget.find(params[:id])
    @budget_assignees = @budget.family.members.map { |member| @budget.budget_assignees.where(user: member).present? ? @budget.budget_assignees.where(user: member) : @budget.budget_assignees.build(user: member) }
  end

  def update
    @budget = Budget.find(params[:id])

    if @budget.update(budget_params)
      redirect_to family_path(@budget.family)
    else
      flash[:alert] = @budget.errors
      redirect_to edit_budget_path(family_id: @budget.family.id)
    end
  end

  def destroy
    @budget = Budget.find(params[:id])
    family = @budget.family
    @budget.destroy

    redirect_to family_path(family), status: :see_other
  end
  
  private
    def budget_params
      params.require(:budget).permit(:name, :amount, :family_id, :period, budget_assignees_attributes: [:id, :user_id, :percentage])
    end
end
