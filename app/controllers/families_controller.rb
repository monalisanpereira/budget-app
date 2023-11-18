class FamiliesController < ApplicationController
  before_action :require_user

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      @family.family_members.create(user: current_user, is_owner: true)
      redirect_to family_path(@family)
    else
      redirect_to new_family_path
    end
  end

  def edit
    @family = Family.find(params[:id])
    return redirect_to root_path unless @family.members.include?(current_user)
  end

  def update
    @family = Family.find(params[:id])
    return redirect_to root_path unless @family.members.include?(current_user)

    if @family.update(family_params)
      redirect_to family_path(@family)
    else 
      redirect_to edit_family_path(@family) 
    end 
  end

  def show
    @family = Family.find(params[:id])

    return redirect_to root_path unless @family.members.include?(current_user)
  end

  def destroy
    @family = Family.find(params[:id])

    return redirect_to root_path unless @family.members.include?(current_user)

    @family.destroy

    redirect_to root_path
  end

  private

  def family_params
    params.require(:family).permit(:family_name)
  end
end
