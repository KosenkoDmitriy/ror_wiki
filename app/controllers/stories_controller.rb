class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def ajax
    get_stories
  end


  def index
    get_stories
  end


  def show
    id = params[:id].to_i if params[:id].present?
    @story = Story.find(id) if Story.exists?(id)

    tid = params[:topic_id]
    @topic = Topic.find(tid) if Topic.exists?(tid)
    # @topic = @story.try(:topics).try(:last)
    # redirect_to topic_unconfirmed_story_path @topic, @story
  end


  def new
    @topic, @story = get_topic_story()
    redirect_to new_topic_unconfirmed_story_path @topic
  end


  def create
    @topic, @story = get_topic_story()
    redirect_to new_topic_unconfirmed_story_path @topic
  end


  def edit
    @topic, @story = get_topic_story()
  end


  def update
    @topic, @story = get_topic_story()
    new_story = create_story_unconfirmed

    if simple_captcha_valid?
      if new_story.save!
        # redirect_to_edit new_story
        redirect_to topic_unconfirmed_story_path @topic, new_story
      else
        redirect_to_edit @story
      end
    else
      #todo: display error message to frontend
      redirect_to_edit @story
    end
  end


  private

  def get_topic_story
    id = params[:id]
    story = Story.find(id) if Story.exists?(id)

    tid = params[:topic_id]
    topic = Topic.find(tid) if Topic.exists?(tid)
    # @topic = @story.try(:topics).try(:last)
    return topic, story
  end

  def story_params
    #params.require(:story).permit(:title, :text, :topic_ids, :source_ids,  topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def sources_params
    params.require(:story).permit(sources_attributes: [:id, :title, :url, :_destroy])
  end

  def create_story_unconfirmed
    @story.attributes = story_params
    new_story = @story.dup #@story.clone for rails < 3.1
    new_story.topics = @story.topics.dup
    new_story.sources = @story.sources.dup
    new_story.is_approved = false
    return new_story
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
