class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def ajax
    get_stories
  end


  def index
    get_stories
  end


  def show
    id = params[:id] if params[:id].present?
    @story = Story.find(id)

    tid = params[:topic_id]
    @topic = Topic.find(tid) if Topic.exists?(tid)
    # @topic = @story.try(:topics).try(:last)
  end


  # def new
  #   tid = params[:topic_id]
  #   @topic = Topic.find(tid) if Topic.exists?(tid)
  #
  #   @story = Story.new
  #   # @topic = @story.try(:topics).try(:last)
  # end


  # def create
  #   tid = params[:topic_id]
  #   @topic = Topic.find(tid) if Topic.exists?(tid)
  #
  #   if simple_captcha_valid?
  #     @story = Story.new(story_params)
  #     if @story.save!
  #       redirect_to topic_unconfirmed_story_path(@topic, @story)
  #     else
  #       render new_topic_story_path(@topic)
  #     end
  #   else
  #     #todo: display error message to frontend
  #     render new_topic_story_path(@topic)
  #   end
  # end


  # def edit
  #   id = params[:id]
  #   @story = Story.find(id) if Story.exists?(id)
  #
  #   tid = params[:topic_id]
  #   @topic = Topic.find(tid) if Topic.exists?(tid)
  #   # @topic = @story.try(:topics).try(:last)
  #
  #   # redirect_to_edit
  # end


  # def update
  #   new_story, @topic = create_story_unconfirmed
  #
  #   if simple_captcha_valid?
  #     if new_story.save!
  #       # redirect_to_edit new_story
  #       redirect_to topic_unconfirmed_story_path @topic, new_story
  #     else
  #       redirect_to_edit @story
  #     end
  #   else
  #     #todo: display error message to frontend
  #     redirect_to_edit @story
  #   end
  # end


  private


  def story_params
    #params.require(:story).permit(:title, :text, :topic_ids, :source_ids,  topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def sources_params
    params.require(:story).permit(sources_attributes: [:id, :title, :url, :_destroy])
  end

  def create_story_unconfirmed
    tid = params[:topic_id]
    topic = Topic.find(tid) if Topic.exists?(tid)
    # topic = story.try(:topics).try(:last)

    id = params[:id]
    @story = Story.find(id) if Story.exists?(id)


    # new_story = Story.new(story_params.except(:id, :is_approved,:sources_attributes ))
    #new_story.save!
    # new_story.topics.build
    # new_story.topics = [topic]
    # story.attributes = story_orig.attributes
    # story.id=nil
    # story.is_approved=false
    # story.save!
    #@story.save!

    new_story = @story.dup #@story.clone for rails < 3.1
    new_story.save

    #new_story = Story.new(story_params.except(:id, :is_approved, :sources_attributes ))
    # new_story.save!
    # new_story.update_attributes(params[:story][:sources_attributes])

    # new_story.update_attributes(story_params)
    # new_story.update_attributes(sources_params)
    # new_story.assign_attributes( sources_params)
    # source_ids = params[:story][:sources_attributes]
    # if source_ids.present? and source_ids.any?
    #   source_ids.each do |source_id|
    #     if Source.exists?(source)
    #       source = Source.find(source)
    #       new_story.sources << source if new_story.present? and new_story.sources.present? and !new_story.sources.exists?(source)
    #     end
    #   end
    # end
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

  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(date_time: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, date_time: :desc, title: :asc).try(:where, is_approved: true).try(:page, page) if topic.present?
    return stories, topic
  end
end
