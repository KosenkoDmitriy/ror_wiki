class StoriesController < ApplicationController
  def index
    topic_id = params[:topic_id] if params[:topic_id].present?
    @stories, @topic = get_stories_and_topic_by_topic_id(topic_id)
    @story = @stories.try(:first)
  end

  def show
    topic_id = params[:topic_id] if params[:topic_id].present?
    id = params[:id] if params[:id].present?
    @stories, @topic = get_stories_and_topic_by_topic_id(topic_id)
    @story = Story.find_by(id:id) if Story.exists?(id:id)
  end

  private
  def get_stories_and_topic_by_topic_id(topic_id)
    topic = Topic.find_by(id:topic_id) if Topic.exists?(id:topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(updated_at: :desc, title: :asc)
    stories = topic.stories.order(updated_at: :desc, title: :asc) if topic.present? && topic.stories.present?
    return stories, topic
  end
end
