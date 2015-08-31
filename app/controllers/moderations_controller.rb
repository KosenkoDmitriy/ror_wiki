class ModerationsController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def show
    @story = get_story_by_params()
    @moderation = get_moderation_by_params()
    @story = @moderation.try(:story)  if !@story.present?# && @moderation.present?
  end

  def edit
    @story = get_story_by_params()
    # @story = @moderation.try(:story)
    @moderation = get_moderation_by_params()

    @sources, @topics = get_sources_and_topics()
    @story, @topic = get_story_and_topic_from_params()
  end

  def update
    @sources, @topics = get_sources_and_topics()
    @story, @topic = get_story_and_topic_from_params()

    @moderation = get_moderation_by_params()
    if simple_captcha_valid?
      # @moderation.update(moderation_params)
      @moderation.update_attributes(moderation_params)
      if @story.present?
        @story.moderations << @moderation
        @story.save
      end
      if @moderation.save
        redirect_to (@moderation)
      else
        render "edit"
      end
    else
      #todo: display error message to frontend
      render "edit"
    end
  end

  def new
    @story = get_story_by_params()
    @moderation = get_moderation_by_params()

    @sources, @topics = get_sources_and_topics()
    @story, @topic = get_story_and_topic_from_params()
  end

  def create
    @sources, @topics = get_sources_and_topics()
    @story, @topic = get_story_and_topic_from_params()

    @moderation = get_moderation_by_params()
    if simple_captcha_valid?
      @moderation.update_attributes(moderation_params)
      if @moderation.save!
        redirect_to (@moderation)
      else
        render "new"
      end
    else
      #todo: display error message to frontend
      render "new"
    end
  end

  private
  def moderation_params
    params.require(:moderation).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def get_story_by_params
    story_id = params[:story_id]
    if Story.exists?(story_id)
      story = Story.find(story_id)
    # else
    #   story = Story.find(story_id)
    end

    return story
  end

  def get_moderation_by_params
    id = params[:id]
    if Moderation.exists?(id)
      moderation = Moderation.find(id)
    else
      moderation = Moderation.new
    end
    return moderation
  end

  def get_sources_and_topics
    sources = Source.order(title: :asc, updated_at: :desc)
    topics = Topic.order(title: :asc, date_time: :desc)
    return sources, topics
  end

  def get_story_and_topic_from_params
    story_id = params[:story_id]
    #story_id = story_id.to_i
    story = Story.find(story_id) if Story.exists?(story_id)

    topic_id = params[:topic_id]
    topic = Topic.find(topic_id) if Topic.exists?(topic_id)
    return story, topic
  end
end
