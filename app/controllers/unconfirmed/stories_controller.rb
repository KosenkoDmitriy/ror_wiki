class Unconfirmed::StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def show
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def edit
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def new
    @errors = []
    @story, @topic = get_uncofirmed_story_and_topic_from_params
    orig_story_id = params[:orig_story_id].to_i if params[:orig_story_id].present?
    if orig_story_id.present? && orig_story_id > 0
      if Story.exists?(id:orig_story_id)
        story = Story.find(orig_story_id)
        @story = clone_story(story) if story.present? and story.try(:id).try(:present?)
        # if @story.save!
        #   redirect_to edit_topic_unconfirmed_story_path @topic, @story
        # else
        #   @errors << t("story.error.create")
        # end
      else
        @errors << t("no_story")
      end
    else
      # @errors << t("no_story")
    end
  end

  def index
    @story, @topic = get_uncofirmed_story_and_topic_from_params
    redirect_to topic_path @topic
  end

  def update
    @errors = []
    @story, @topic = get_uncofirmed_story_and_topic_from_params
    if simple_captcha_valid?
      @story.update_attributes(story_params)
      @story.is_approved = false
      if @story.save!
        redirect_to topic_unconfirmed_story_path @topic, @story
      else
        @errors << I18n.t("story.error.edit")
        render "edit"
      end
    else
      @errors << I18n.t("simple_captcha.message.default")
      render "edit"
    end
  end

  def create
    @errors = []
    @story, @topic = get_uncofirmed_story_and_topic_from_params()
    if simple_captcha_valid?
      @story.is_approved = false
      # @story.try(:topics) << @topic if !@story.try(:topics).try(:exists?, @topic.try(:id))
      @story.try(:topics) << @topic if !@story.try(:topics).try(:exists?, @topic)
      if @story.save!
        flash[:notice] = I18n.t("story.success.create")
        redirect_to topic_unconfirmed_story_path(@topic, @story)
      else
        @errors << I18n.t("story.error.create")
        render "new"
      end
    else
      @errors << I18n.t("simple_captcha.message.default")
      render "new"
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def story_params_for_create
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:title, :url, :_destroy])
  end

  def clone_story orig_story
    new_story = orig_story.dup #orig_story.clone for rails < 3.1
    new_story.topics = orig_story.try(:topics).try(:dup)
    new_story.sources = orig_story.try(:sources).try(:dup)
    new_story.is_approved = false
    return new_story
  end


  def get_uncofirmed_story_and_topic_from_params
    tid = params[:topic_id] if params[:topic_id].present?
    topic = Topic.find(tid) if Topic.exists?(tid)

    id = params[:id].to_i if params[:id].present?
    sid = params[:story_id].to_i if params[:story_id].present?

    id = sid if id.blank? and sid.present?

    if Story.exists?(id)
      story = Story.find(id)
    else
      begin
        story = Story.new story_params_for_create
      rescue Exception => exception
        story = Story.new
      end
    end
    return story, topic
  end

end
