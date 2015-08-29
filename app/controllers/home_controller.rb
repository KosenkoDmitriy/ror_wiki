class HomeController < ApplicationController

  def index
    # page = params[:page] if params[:page].present?
    page = params[:page] || 1
    @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
  end

  # def details
  #
  # end

end
