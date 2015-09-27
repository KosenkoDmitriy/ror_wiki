class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def ajax
    get_stories
  end


  def index
    @meta_title = t("meta.title")
    @meta_text = t("meta.text")
    get_stories
  end


  def show
    @topic, @story = get_topic_story()
    if @story.blank?
      @text = "#{t(:http404)}: #{t(:no_story)}"
      render(status: 404, template:"errors/404")
      # render(status: 404, text:@text, template:"errors/404.html")
      # render(status: 404, text: @text: #{t(:no_story)}", template:"public/404.html")
      # render(status: 404, file:"#{Rails.root}/public/404.html")
      # render(status: 404, file:"public/404")
    end
    @meta_title = "#{@story.try(:title)} via Wikitimelines"
    @meta_text = "look at other news sites, what do they do?"
  end


  def new
    @topic, @story = get_topic_story()
    redirect_to_unconfirmed_new_url()
  end


  def edit
    @errors = []
    @topic, @story = get_topic_story()
    redirect_to_unconfirmed_new_url()
  end


  private

  def story_params
    params.require(:story).permit(:title, :text, :date_time, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def redirect_to_unconfirmed_edit_url
    begin
      url = "/topics/#{@topic.try(:id)}/unconfirmed/stories/#{@story.try(:id)}/edit?orig_story_id=#{@story.try(:id)}" #todo: quick fix
      redirect_to url
    rescue Exception => e
      redirect_to topic_story_path(@topic, @story)
    end
  end

  def redirect_to_unconfirmed_new_url
    begin
      id = params[:format]
      tid = params[:topic_id]
      url = "/topics/#{tid}/unconfirmed/stories/new?orig_story_id=#{id}" #todo: quick fix
      redirect_to url
    rescue Exception => e
      redirect_to topic_story_path(@topic, @story)
    end
  end

  def get_topic_story
    id = params[:id]
    story = Story.find(id) if Story.exists?(id)

    tid = params[:topic_id]
    topic = Topic.find(tid) if Topic.exists?(tid)
    return topic, story
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
