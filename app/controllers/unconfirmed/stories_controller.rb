class Unconfirmed::StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def show
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def edit
    @story, @topic = get_uncofirmed_story_and_topic_from_params
  end

  def update
    @story, @topic = get_uncofirmed_story_and_topic_from_params
    if simple_captcha_valid?
      # @moderation.update_attributes(story_params.except(:id,:sources_attributes))
      @story.update_attributes(story_params)

      if @story.save!
        redirect_to (@story)
      else
        render "edit"
      end
    else
      #todo: display error message to frontend
      # redirect_to_new_moderation
      render "edit"
    end  end

  private

  def story_params
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def get_uncofirmed_story_and_topic_from_params
    tid = params[:topic_id] if params[:topic_id].present?
    id = params[:id] if params[:id].present?
    sid = params[:story_id] if params[:story_id].present?
    id = sid if id.blank? and sid.present?
    story = Story.find(id)# if Story.exists?(id)
    topic = Topic.find(tid) if Topic.exists?(tid)
    return story, topic
  end

end
