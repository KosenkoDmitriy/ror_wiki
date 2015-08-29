class StoriesController < ApplicationController

  def index
    page = params[:page] || 1
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = @stories.try(:first)
    else
      @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
      @story = @stories.try(:first)
    end
  end

  def show
    page = params[:page] || 1
    id = params[:id] if params[:id].present?
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = Story.find_by(id: id) if Story.exists?(id: id)
    elsif id.present?
      @story = Story.find(id)
      @stories = @story.try(:topics).try(:last).try(:stories).try(:order, updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
    else
      # @stories = Story.order(created_at: :desc, updated_at: :desc, title: :asc)
      # @story = Story.last
    end
  end

  private
  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(updated_at: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, updated_at: :desc, title: :asc).try(:page, page) if topic.present?
    return stories, topic
  end
end
