class ModerationsController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def show
    @story = get_story_by_params()
    @topic = @story.try(:topics).try(:last)
    @moderation = get_moderation_by_params()
    @story = @moderation.try(:story)  if !@story.present?# && @moderation.present?
    @topic = @moderation.try(:topics).try(:last)
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

    if @story.present?
      @moderation.title = @story.title
      @moderation.text = @story.text
      # @moderation.sources = @story.sources
      @moderation.date_time = @story.date_time
    end
  end

  def create
    @sources, @topics = get_sources_and_topics()
    @story, @topic = get_story_and_topic_from_params()

    @moderation = get_moderation_by_params()
    if simple_captcha_valid?
      # @moderation.update_attributes(moderation_params.except(:id,:sources_attributes))
      @moderation.update_attributes(moderation_params)

      if @moderation.save!
        # redirect_to (@moderation)
        redirect_to_edit_moderation()
      else
        redirect_to_new_moderation()
      end
    else
      #todo: display error message to frontend
      redirect_to_new_moderation
    end
  end

  private

  def redirect_to_edit_moderation
    if @topic.present? && @moderation.present?
      if  @story.present?
        redirect_to edit_topic_story_moderation_path(@topic, @story, @moderation)
      else
        redirect_to edit_topic_moderation_path(@topic, @moderation)
      end
    else
      render "edit"
    end
  end

  def redirect_to_new_moderation
    if @topic.present?
      if  @story.present?
        redirect_to new_topic_story_moderation_path(@topic, @story)
      else
        redirect_to new_topic_moderation_path(@topic)
      end
    else
      render "new"
    end
  end


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
