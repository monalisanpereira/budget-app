class ExpendituresController < ApplicationController
  def new
    @expenditure = Expenditure.new(family: Family.find(params[:family_id]))
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
      params.require(:expenditure).permit(:description, :amount, :family_id, :date)
    end
end
