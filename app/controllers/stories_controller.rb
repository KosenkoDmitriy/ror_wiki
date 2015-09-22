class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def ajax
    get_stories
  end


  def index
    get_stories
  end


  def show
    @topic, @story = get_topic_story()
  end


  def new
    @topic, @story = get_topic_story()
    redirect_to new_topic_unconfirmed_story_path @topic
  end


  def edit
    @errors = []
    @topic, @story = get_topic_story()
    new_story = clone_story(@story)
    if new_story.save!
      redirect_to edit_topic_unconfirmed_story_path @topic, new_story
    else
      @errors << t("story.error.edit")
    end
  end


  private

  def clone_story orig_story
    new_story = orig_story.dup #orig_story.clone for rails < 3.1
    new_story.topics = orig_story.topics.dup
    new_story.sources = orig_story.sources.dup
    new_story.is_approved = false
    return new_story
  end

  def get_topic_story
    id = params[:id]
    story = Story.find(id) if Story.exists?(id)

    tid = params[:topic_id]
    topic = Topic.find(tid) if Topic.exists?(tid)
    return topic, story
  end

  def story_params
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def redirect_to_edit story
    if story.present?
      redirect_to edit_topic_story_path(@topic, story)
    else
      redirect_to edit_topic_path(story)
    end
  end

  def get_stories
    page = params[:page] || 1
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = @stories.try(:first)
    else
      @stories = Story.order(date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page)
      @story = @stories.try(:first)
    end
  end

  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(date_time: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page) if topic.present?
    return stories, topic
  end
end
