class TopicsController < ApplicationController

  def index
    # @topics = get_approved_topics()
    # @topic = @topics.try(:first)
    # @stories, @story = get_stories_and_story_from_topic(@topic)
    redirect_to root_path
  end

  def show
    get_stories_of_topic()
  end

  def ajax
    get_stories_of_topic()
  end

  private

  def get_stories_of_topic
    @topics = get_approved_topics()
    id = params[:id] if params[:id].present?
    if Topic.exists?(id)
      @topic = Topic.find(id)
      @stories, @story = get_stories_and_story_from_topic(@topic)
    end
  end

  def get_approved_topics()
    page = params[:page] || 1
    topics = Topic.order(date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page)
    return topics
  end

  def get_stories_and_story_from_topic(topic)
    # count = topic.try(:stories).try(:count) || 0
    # stories = topic.try(:stories).try(:order, date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, 0).try(:per, count)
    page = params[:page] || 1
    stories = topic.try(:stories).try(:order, date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page)
    story = stories.try(:first)
    return stories, story
  end
end
