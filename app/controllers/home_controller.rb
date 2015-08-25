class HomeController < ApplicationController

  def index
    @stories = Story.order(updated_at: :asc, created_at: :asc)
  end

  # def details
  #
  # end

end
