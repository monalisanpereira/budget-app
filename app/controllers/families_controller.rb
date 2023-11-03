class FamiliesController < ApplicationController
  def show
    @family = Family.find(params[:id])
  end
end
