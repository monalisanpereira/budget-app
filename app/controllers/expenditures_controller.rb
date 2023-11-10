class ExpendituresController < ApplicationController
  def new
    family = Family.find(params[:family_id])
    @budgets = family.budgets
    @members = family.members

    if params[:budget_id].present?
      @expenditure = Expenditure.new(family: family, budget: Budget.find(params[:budget_id]))
    else
      @expenditure = Expenditure.new(family: family)
    end

    @expenditure_assignees = @members.map { |member| @expenditure.expenditure_assignees.build(user: member) }
  end

  def edit
    @expenditure = Expenditure.find(params[:id])
    @budgets = @expenditure.family.budgets
    if @expenditure.expenditure_assignees.present?
      @expenditure_assignees = @expenditure.expenditure_assignees
    else
      @expenditure_assignees = @expenditure.family.members.map { |member| @expenditure.expenditure_assignees.build(user: member) }
    end
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)

    if @expenditure.save
      redirect_to family_path(@expenditure.family)
    else
      flash[:alert] = @expenditure.errors
      redirect_to new_expenditure_path(family_id: @expenditure.family.id)
    end
  end

  def update
    @expenditure = Expenditure.find(params[:id])

    if @expenditure.update(expenditure_params)
      if expenditure_params[:budget_id].present? && @expenditure.expenditure_assignees.present?
        @expenditure.expenditure_assignees.destroy_all
      end
      redirect_to family_path(@expenditure.family)
    else
      flash[:alert] = @expenditure.errors
      redirect_to edit_expenditure_path(family_id: @expenditure.family.id)
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
      params.require(:expenditure).permit(:description, :amount, :family_id, :date, :budget_id, expenditure_assignees_attributes: [:id, :user_id, :percentage])
    end
end
