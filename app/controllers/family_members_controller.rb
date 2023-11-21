class FamilyMembersController < ApplicationController
  before_action :require_user

  def create
    family = Family.find(family_member_params[:family_id])
    @family_member = family.family_members.build(user: User.find_by_email(family_member_params[:user_email]))
    if @family_member.save
      redirect_to manage_members_family_path(family)
    else
      redirect_to family_path(family)
    end
  end

  def destroy
    family_member = FamilyMember.find(params[:id])
    family = family_member.family
    if family_member.destroy
      redirect_to manage_members_family_path(family)
    else
      redirect_to family_path(family)
    end
  end

  def family_member_params
    params.require(:family_member).permit(:user_email, :family_id)
  end
end
