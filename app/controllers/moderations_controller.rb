class ModerationsController < ApplicationController
  def show
    id = params[:id]
    if Moderation.exists?(id)
      mstory = Moderation.find(id)
      @story = mstory.try(:story)
    end
  end
end
