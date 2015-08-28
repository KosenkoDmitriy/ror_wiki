class TopicsController < ApplicationController
  def index
    @topics = Topic.order(updated_at: :desc, title: :asc)
    @topic = @topics.try(:first)
    @stories = @topic.try(:stories).try(:order, created_at: :desc, updated_at: :desc, title: :asc)
  end

  def show
    @topics = Topic.order(updated_at: :desc, title: :asc)
    id = params[:id] if params[:id].present?
    @topic = Topic.find(id) if Topic.exists?(id)
    @stories = @topic.try(:stories).try(:order, created_at: :desc, updated_at: :desc, title: :asc)
    @story = @stories.try(:last)
  end

  private

end
