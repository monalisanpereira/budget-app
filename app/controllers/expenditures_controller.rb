class ExpendituresController < ApplicationController
  def new
    family = Family.find(params[:family_id])
    @budgets = family.budgets

    if params[:budget_id].present?
      @expenditure = Expenditure.new(family: family, budget: Budget.find(params[:budget_id]))
    else
      @expenditure = Expenditure.new(family: family)
    end
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)

    if @expenditure.save
      redirect_to family_path(@expenditure.family)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def expenditure_params
      params.require(:expenditure).permit(:description, :amount, :family_id, :date, :budget_id)
    end
end
