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
  
    private
      def budget_params
        params.require(:budget).permit(:name, :amount, :family_id)
      end
end
