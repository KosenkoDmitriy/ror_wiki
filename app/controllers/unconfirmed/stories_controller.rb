class Unconfirmed::StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def show
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def edit
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def new
    # tid = params[:topic_id] if params[:topic_id].present?
    # @topic = Topic.find(tid) if Topic.exists?(tid)
    # @story = Story.new
    @story, @topic = get_uncofirmed_story_and_topic_from_params

  end

  def update
    @errors = []
    @story, @topic = get_uncofirmed_story_and_topic_from_params
    if simple_captcha_valid?
      # @moderation.update_attributes(story_params.except(:id,:sources_attributes))
      @story.update_attributes(story_params)

      if @story.save!
        redirect_to topic_unconfirmed_story_path @topic, @story
      else
        render "edit"
      end
    else
      #todo: display error message to frontend
      # redirect_to_new_moderation
      @errors << I18n.t("simple_captcha.message.default")
      render "edit"
    end
  end

  def create
    @story, @topic = get_uncofirmed_story_and_topic_from_params()

    if simple_captcha_valid?
      @story = Story.new story_params if @story.id.blank? && params[:story].present?

      # @moderation.update_attributes(moderation_params.except(:id,:sources_attributes))
      @story.update_attributes(story_params)
      # dt=story_params[:date_time]
      # dt3=params[:story][:date_time]
      # @story.date_time = dt
      @story.topics << @topic if !@story.topics.exists?(@topic)
      if @story.save!
        # redirect_to (@story)
        # redirect_to "show"
        # render "new"
        redirect_to topic_unconfirmed_story_path(@topic, @story)

      else
        render "new"
      end
    else
      #todo: display error message to frontend
      render "new"
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def get_uncofirmed_story_and_topic_from_params
    tid = params[:topic_id] if params[:topic_id].present?
    topic = Topic.find(tid) if Topic.exists?(tid)

    id = params[:id] if params[:id].present?
    sid = params[:story_id] if params[:story_id].present?

    id = sid if id.blank? and sid.present?

    # if Story.exists?(id)
      story = Story.find(id)
    #   story = story_orig.dup
    # end
    return story, topic
  end

end
