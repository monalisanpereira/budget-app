class FamiliesController < ApplicationController
  def index; end
  
  def show
    @family = Family.find(params[:id])
  end
end
