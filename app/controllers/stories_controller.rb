class StoriesController < ApplicationController
  include SimpleCaptcha::ControllerHelpers

  def index
    page = params[:page] || 1
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = @stories.try(:first)
    else
      @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:where, is_approved:true).try(:page, page)
      @story = @stories.try(:first)
    end
  end

  def show
    page = params[:page] || 1
    id = params[:id] if params[:id].present?
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = Story.find_by(id: id) if Story.exists?(id: id)
    elsif id.present?
      @story = Story.find(id)
      @stories = @story.try(:topics).try(:last).try(:stories).try(:order, updated_at: :desc, created_at: :desc, title: :asc).try(:where, is_approved:true).try(:page, page)
      #@stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc) if @stories.blank?
    else
      # @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc)
      # @story = Story.last
    end
  end

  # def edit
  #   page = params[:page] || 1
  #   id = params[:id]
  #
  #   #@stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
  #   @story = Story.find(id) if Story.exists?(id)
  #   #@topic = @story.try(:topics).try(:last)
  #
  #   @topics = Topic.order(title: :asc)
  #   @sources = Source.order(title: :asc)
  # end

  # def new
  #   #todo: params[:topic_id]
  #   page = params[:page] || 1
  #   #@stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
  #   @story = Story.new
  #
  #   @topics = Topic.order(title: :asc)
  #   @sources = Source.order(title: :asc)
  #
  #   #@story.build(:moderations)
  #   #@story.build(:sources)
  #   #@story.build(:images)
  # end


  # def update
  #   #page = params[:page] || 1
  #   id = params[:id]
  #   @story = Story.find(id) if Story.exists?(id)
  #   @topics = Topic.order(title: :asc)
  #   @sources = Source.order(title: :asc)
  #
  #   # @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
  #   # @topic = @story.try(:topics).try(:last)
  #   # if simple_captcha_valid?
  #   update_or_create_story_moderations(params)
  #   # else
  #   #todo: display error message to frontend
  #   # render "edit"
  #   # end
  # end
  #
  #
  # def create
  #   if simple_captcha_valid?
  #     update_or_create_story_moderations(params)
  #   else
  #     render "new"
  #     #todo: display error message to frontend
  #   end
  # end


  private

  def update_or_create_story params
    # TODO: assign topic to story
    # @story = Story.find_or_create_by!(story_params)
    topic_id = params[:topic]
    title = params[:story][:title]
    id = params[:id]
    #@topic = Topic.find(topic_id) if Topic.exists?(id: topic_id)
    if Story.exists?(title: title)
      @story = Story.find_by(title: title)
      #@story.topics << @topic if !@story.topics.exists?(@topic)
      #@story.try(:topics).try(:find, @topic)
      @story.update(story_params)
      @story.update_attributes(story_params)

      m = Moderation.find_or_create_by!(moderation_params)
      @story.moderations << m
      if @story.save
        redirect_to(@story)
      else
        render "edit"
      end
      # if (@story.save)
      #   #redirect to success page
      # else
      #   #redirect to new action with errors
      # end
    elsif Story.exists?(id: id) #edit action
      @story = Story.find(id)
      @story.update(story_params)
      @story.update_attributes(story_params)
      # params2 = {:topic_ids => [1,2,3]}
      # @story.update_attributes( params2 )
      m = Moderation.find_or_create_by!(moderation_params)
      @story.moderations << m
      if @story.save!
        redirect_to(@story)
      else
        render "edit"
      end
    else
      @story = Story.new(story_params)
      @story.update(story_params)
      @story.update_attributes(story_params)
      #@story.topics << @topic if !@story.topics.exists?(@topic)
      @story.is_approved = false
      if @story.save
        redirect_to stories_path
      else
        render "new"
      end
    end
    # redirect_to stories_path #TODO: must be commented after @story.save implementation
  end

  def get_moderation
    m=Moderation.find_or_create_by(story_params.except(:sources_attributes, :topic_ids))
    m.save
    m.update_attributes(story_params.except(:sources_attributes))
    m.update_attributes(story_params.except(:topic_ids))


    # sources = params[:story][:sources_attributes]
    # #source_ids = []
    #
    # sources.each do |i, source|
    #   if (source[:_destroy]=="1")
    #     # Source.delete(source[:id])
    #   else
    #     s = Source.find_or_create_by(title: source["title"], url: source["url"])
    #     m.sources << s
    #   end
    #
    # end
    #
    # m.sources = m.sources.uniq!



    # story = Story.new(story_params.except(:sources_attributes))
    # m = Moderation.find_or_create_by!(title: story.title, text: story.text, stext: story.stext)
    # story.try(:sources).try(:each) do |source|
    #   m.sources << source
    # end
    # m.sources = story.sources
    # m.topic_ids = story.topic_ids
    #m.attributes = story.attributes
    #m.update_attributes(story_params.except(:sources_attributes))
    m.save
    return m
  end

  def update_or_create_story_moderations params
    # TODO: assign topic to story
    topic_id = params[:topic]
    title = params[:story][:title]
    id = params[:id]
    #@topic = Topic.find(topic_id) if Topic.exists?(id: topic_id)
    if Story.exists?(title: title) # edit existing story (found by title) >> add a new moderation object to story.moderations for moderation queue
      @story = Story.find_by(title: title)
      moderation = get_moderation()
      @story.moderations << moderation
      if @story.save
        redirect_to(moderation) #todo: edit moderation story if required
      else
        render "edit"
      end
    elsif Story.exists?(id: id) # edit existing story (found by id) >> add a new moderation object to story.moderations for moderation queue
      @story = Story.find(id)
      moderation = get_moderation()
      @story.moderations << moderation
      if @story.save!
        redirect_to(moderation) #todo: edit moderation story if required
      else
        render "edit"
      end
    else #create a new story with status: is_approved = false
      @story = Story.new(story_params)
      @story.update(story_params)
      @story.update_attributes(story_params)
      @story.is_approved = false
      if @story.save
        redirect_to stories_path #todo: display unconfirmed story (story in moderation queue) if required
      else
        render "new"
      end
    end
  end

  def story_params
    #params.require(:story).permit(:title, :text, :topic_ids, :source_ids,  topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
    params.require(:story).permit(:title, :text, topic_ids: [], sources_attributes: [:id, :title, :url, :_destroy])
  end

  def moderation_params
    params.require(:story).permit(:title, :text) #, sources_attributes:[:title, :url, :_destroy]) #todo: source_ids and topic_ids ?
  end


  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(updated_at: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, updated_at: :desc, title: :asc).try(:where, is_approved:true).try(:page, page) if topic.present?
    return stories, topic
  end
end
