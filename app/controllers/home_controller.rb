class HomeController < ApplicationController

  def index
    # page = params[:page] if params[:page].present?
    page = params[:page] || 1
    @stories = Story.order(date_time: :desc, title: :asc).try(:page, page)
  end

  # def details
  #
  # end

end
