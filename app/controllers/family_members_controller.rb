class FamilyMembersController < ApplicationController
  before_action :require_user

  def create
    family = Family.find(family_member_params[:family_id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_admin?(current_user)

    @family_member = family.family_members.build(user: User.find_by_email(family_member_params[:user_email]))
    if @family_member.save
      redirect_to manage_members_family_path(family)
    else
      redirect_to manage_members_family_path(family), alert: t('alerts.errors.family_member_create')
    end
  end

  def update
    @family_member = FamilyMember.find(params[:id])

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless @family_member.family.members.include?(current_user)
    return redirect_to family_path(@family_member.family), alert: t('alerts.errors.no_permission') unless @family_member.family.member_is_above_admin?(current_user)

    if @family_member.update(family_member_params)
      redirect_to manage_members_family_path(@family_member.family)
    else 
      redirect_to manage_members_family_path(@family_member.family), alert: t('alerts.errors.family_member_update')
    end 
  end

  def destroy
    family_member = FamilyMember.find(params[:id])
    family = family_member.family

    return redirect_to root_path, alert: t('alerts.errors.no_permission') unless family.members.include?(current_user)
    return redirect_to family_path(family), alert: t('alerts.errors.no_permission') unless family.member_is_above_admin?(current_user)

    if family_member.destroy
      redirect_to manage_members_family_path(family)
    else
      redirect_to manage_members_family_path(family), alert: t('alerts.errors.family_member_destroy')
    end
  end

  def family_member_params
    params.require(:family_member).permit(:user_email, :family_id, :role)
  end
end
