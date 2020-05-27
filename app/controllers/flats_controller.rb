class FlatsController < ApplicationController
  def index
    if params[:query].present?
      @flats = Flat.search_by_name_and_description(params[:query])
    else
      @flats = Flat.all
    end
  end

  def search_results
    @flats = Flat.search_by_name_and_description(params[:query])
    respond_to do |format|
      format.js
    end
  end
end
