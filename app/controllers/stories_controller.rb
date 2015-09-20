class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def ajax
    get_stories
  end


  def index
    get_stories
  end

  def unconfirmed
    # id = params[:id] if params[:id].present?
    # tid = params[:topic_id] if params[:topic_id].present?
    # sid = params[:story_id] if params[:story_id].present?
    # @story = Story.find_by(id: sid) if Story.exists?(id: sid)
    # @topic = Topic.find_by(id: tid) if Topic.exists?(id: tid)
    @story, @topic = get_uncofirmed_story_and_topic_from_params()
    render template: "stories/unconfirmed/show"
  end

  def show
    id = params[:id] if params[:id].present?
    @story = Story.find(id)
    @topic = @story.try(:topics).try(:last)
  end


  def new
    tid = params[:topic_id]
    @topic = Topic.find(tid) if Topic.exists?(tid)
    @story = Story.new
    # @topic = @story.try(:topics).try(:last)
  end


  def create
    tid = params[:topic_id]
    @topic = Topic.find(tid) if Topic.exists?(tid)

    if simple_captcha_valid?
      @story = Story.new(story_params)
      if @story.save!
        redirect_to topic_story_story_unconfirmed_path(@topic, @story)
      else
        render new_topic_story_path(@topic)
      end
    else
      #todo: display error message to frontend
      render new_topic_story_path(@topic)
    end
  end


  def edit
    id = params[:id]
    @story = Story.find(id) if Story.exists?(id)

    tid = params[:topic_id]
    @topic = Topic.find(tid) if Topic.exists?(tid)
    # @topic = @story.try(:topics).try(:last)

    # redirect_to_edit
  end


  def update
    new_story, @topic = create_story_unconfirmed

    if simple_captcha_valid?
      if new_story.save!
        # redirect_to_edit new_story
        redirect_to topic_story_story_unconfirmed_path @topic, new_story
      else
        redirect_to_edit @story
      end
    else
      #todo: display error message to frontend
      redirect_to_edit @story
    end
  end


  private

  def get_uncofirmed_story_and_topic_from_params
    tid = params[:topic_id] if params[:topic_id].present?
    sid = params[:story_id] if params[:story_id].present?
    story = Story.find_by(id: sid) if Story.exists?(id: sid)
    topic = Topic.find_by(id: tid) if Topic.exists?(id: tid)
    return story, topic
  end

  def create_story_unconfirmed
    tid = params[:topic_id]
    topic = Topic.find(tid) if Topic.exists?(tid)
    # topic = story.try(:topics).try(:last)

    id = params[:id]
    @story = Story.find(id) if Story.exists?(id)


    new_story = Story.new(story_params.except(:id, :is_approved))
    # story.attributes = story_orig.attributes
    # story.id=nil
    # story.is_approved=false
    # story.save!
    #@story.save!
    #@story.update_attributes(story.attributes.except(:id, :is_approved, :sources))
    return new_story, topic
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

  def story_params
    #params.require(:story).permit(:title, :text, :topic_ids, :source_ids,  topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
    params.require(:story).permit(:title, :text, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(date_time: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page) if topic.present?
    return stories, topic
  end
end
