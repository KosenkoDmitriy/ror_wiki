class HomeController < ApplicationController

  def index
    # page = params[:page] if params[:page].present?
    page = params[:page] || 1
    per_page = params[:per] || 1000
    @stories = Story.order(date_time: :desc, title: :asc).try(:page, page).try(:per,per_page)
  end

  # def details
  #
  # end

end
