class BudgetsController < ApplicationController
  def new
    @budget = Budget.new(family: Family.find(params[:family_id]))
  end
  
  def create
    @budget = Budget.new(budget_params)
  
    if @budget.save
      redirect_to family_path(@budget.family)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget = Budget.find(params[:id])
  end

  def update
    @budget = Budget.find(params[:id])

    if @budget.update(budget_params)
      redirect_to family_path(@budget.family)
    else
      render :edit, status: :unprocessable_entity
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
      params.require(:budget).permit(:name, :amount, :family_id)
    end
end
