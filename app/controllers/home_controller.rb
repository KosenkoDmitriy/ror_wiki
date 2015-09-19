class HomeController < ApplicationController

  def index
    # page = params[:page] if params[:page].present?
    get_story_and_stories
  end

  def home
    get_story_and_stories
  end

  def home2
    get_story_and_stories
  end

  private
  def get_story_and_stories
    page = params[:page] || 1
    per_page = params[:per] || 10
    @stories = Story.order(date_time: :desc, title: :asc).try(:page, page).try(:per,per_page)
    @story = @stories.try(:first)
    @topic = @story.try(:topics).try(:last)
  end
end
