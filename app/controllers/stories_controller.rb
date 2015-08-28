class StoriesController < ApplicationController
  def index
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id)
      @story = @stories.try(:first)
    else
      @stories = Story.order(created_at: :desc, updated_at: :desc, title: :asc)
      @story = Story.last
    end
  end

  def show
    id = params[:id] if params[:id].present?
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id)
      @story = Story.find_by(id: id) if Story.exists?(id: id)
    elsif id.present?
      @story = Story.find(id)
      @stories = @story.try(:topics).try(:last).try(:stories).try(:order, created_at: :desc, updated_at: :desc, title: :asc)
    else
      # @stories = Story.order(created_at: :desc, updated_at: :desc, title: :asc)
      # @story = Story.last
    end
  end

  private
  def get_stories_and_topic_by_topic_id(topic_id)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(updated_at: :desc, title: :asc)
    stories = topic.stories.order(updated_at: :desc, title: :asc) if topic.present? && topic.stories.present?
    return stories, topic
  end
end
