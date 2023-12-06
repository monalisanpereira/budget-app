class ExpendituresController < ApplicationController
  before_action :require_user

  def index
    @family = Family.find(params[:family_id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @family.members.include?(current_user)
  end
  
  def new
    if params[:family_id].present?
      family = Family.find(params[:family_id])
    elsif params[:budget_id].present?
      budget = Budget.find(params[:budget_id])
      family = budget.family
    else
      return redirect_to root_path, alert: t('alerts.errors.expense_create')
    end

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_editor?(current_user)

    @budgets = family.budgets
    @members = family.members

    @expenditure = Expenditure.new(family: family)
    @expenditure.budget = budget if params[:budget_id].present?

    @expenditure_assignees = @members.map { |member| @expenditure.expenditure_assignees.build(user: member) }
  end

  def create
    family = Family.find(expenditure_params[:family_id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_editor?(current_user)

    @expenditure = Expenditure.new(expenditure_params)

    if @expenditure.save
      if @expenditure.budget.present?
        redirect_to budget_path(@expenditure.budget), notice: t('alerts.success.expense_create')
      else
        redirect_to expenditures_path(family_id: @expenditure.family.id), notice: t('alerts.success.expense_create')
      end
    else
      redirect_to family_path(@expenditure.family), alert: t('alerts.errors.expense_create')
    end
  end

  def edit
    @expenditure = Expenditure.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @expenditure.family.members.include?(current_user)
    return redirect_to family_path(@expenditure.family), alert: t('alerts.errors.no_permission') unless @expenditure.family.member_is_above_editor?(current_user)

    @budgets = @expenditure.family.budgets
    @expenditure_assignees = @expenditure.family.members.map { |member| @expenditure.expenditure_assignees.where(user: member).present? ? @expenditure.expenditure_assignees.where(user: member) : @expenditure.expenditure_assignees.build(user: member) }
  end

  def update
    @expenditure = Expenditure.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @expenditure.family.members.include?(current_user)
    return redirect_to family_path(@expenditure.family), alert: t('alerts.errors.no_permission') unless @expenditure.family.member_is_above_editor?(current_user)

    begin
      ActiveRecord::Base.transaction do
        filtered_params = expenditure_params
        if expenditure_params[:budget_id].blank? && expenditure_params[:expenditure_assignees_attributes].present?
          if @expenditure.budget.present?
            @expenditure.update(budget_id: nil)
          else
            expenditure_params[:expenditure_assignees_attributes].each do |assignee|
              if assignee[1]["percentage"].blank?
                expenditure_assignee = @expenditure.expenditure_assignees.find(assignee[1]["id"].to_i)
                expenditure_assignee.destroy if expenditure_assignee
                filtered_params[:expenditure_assignees_attributes]&.delete_if { |_, attrs| attrs["id"] == assignee[1]["id"] }
              end
            end
          end
        elsif expenditure_params[:budget_id].present? && expenditure_params[:expenditure_assignees_attributes].values.map { |attrs| attrs["percentage"].blank? }.all?
          @expenditure.expenditure_assignees.destroy_all if @expenditure.expenditure_assignees.any?
          filtered_params = filtered_params.except(:expenditure_assignees_attributes)
        end

        @expenditure.update!(filtered_params)

        if @expenditure.budget.present?
          redirect_to budget_path(@expenditure.budget), notice: t('alerts.success.expense_update')
        else
          redirect_to expenditures_path(family_id: @expenditure.family.id), notice: t('alerts.success.expense_update')
        end
      end
    rescue StandardError => e
      redirect_to edit_expenditure_path(@expenditure), alert: t('alerts.errors.expense_update')
    end
  end

  def destroy
    @expenditure = Expenditure.find(params[:id])
    family = @expenditure.family

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @expenditure.family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless @expenditure.family.member_is_above_editor?(current_user)

    @expenditure.destroy

    redirect_back(fallback_location: family_path(family))
  end

  private
    def expenditure_params
      params.require(:expenditure).permit(:description, :amount, :family_id, :date, :budget_id, expenditure_assignees_attributes: [:id, :user_id, :percentage])
    end
end
