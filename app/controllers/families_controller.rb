class FamiliesController < ApplicationController
  before_action :require_user

  def show
    @family = Family.find(params[:id])
  end
end
