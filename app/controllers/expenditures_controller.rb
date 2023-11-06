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

  def edit
    @expenditure = Expenditure.find(params[:id])
    @budgets = @expenditure.family.budgets
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)

    if @expenditure.save
      redirect_to family_path(@expenditure.family)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @expenditure = Expenditure.find(params[:id])

    if @expenditure.update(expenditure_params)
      redirect_to family_path(@expenditure.family)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expenditure = Expenditure.find(params[:id])
    family = @expenditure.family
    @expenditure.destroy

    redirect_to family_path(family), status: :see_other
  end

  private
    def expenditure_params
      params.require(:expenditure).permit(:description, :amount, :family_id, :date, :budget_id)
    end
end
