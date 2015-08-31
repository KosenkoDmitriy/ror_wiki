class TopicsController < ApplicationController

  def index
    @topics = get_approved_topics()
    @topic = @topics.try(:first)
    @stories, @story = get_stories_and_story_from_topic(@topic)
  end

  def show
    @topics = get_approved_topics()
    id = params[:id] if params[:id].present?
    if Topic.exists?(id)
      @topic = Topic.find(id)
      @stories, @story = get_stories_and_story_from_topic(@topic)
    end
  end

  private
  def get_approved_topics()
    page = params[:page] || 1
    topics = Topic.order(updated_at: :desc, title: :asc).try(:where, is_approved: true).try(:page, page)
    return topics
  end

  def get_stories_and_story_from_topic(topic)
    count = topic.try(:stories).try(:count) || 0
    stories = topic.try(:stories).try(:order, updated_at: :desc, created_at: :desc, title: :asc).try(:where, is_approved: true).try(:page, 0).try(:per, count)
    story = stories.try(:first)
    return stories, story
  end
end
