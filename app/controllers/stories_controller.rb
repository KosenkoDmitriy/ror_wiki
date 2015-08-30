class StoriesController < ApplicationController

  def index
    page = params[:page] || 1
    topic_id = params[:topic_id] if params[:topic_id].present?
    if topic_id.present?
      @stories, @topic = get_stories_and_topic_by_topic_id(topic_id, page)
      @story = @stories.try(:first)
    else
      @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
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
      @stories = @story.try(:topics).try(:last).try(:stories).try(:order, updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
      #@stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc) if @stories.blank?
    else
      # @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc)
      # @story = Story.last
    end
  end

  def edit
    page = params[:page] || 1
    id = params[:id]

    @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
    @story = Story.find(id) if Story.exists?(id)
    @topic = @story.try(:topics).try(:last)
    @topics = Topic.order(title: :asc)
    # @topic =
  end

  def new
    #todo: params[:topic_id]
    page = params[:page] || 1
    @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
    @story = Story.new
    @topics = Topic.order(title: :asc)
    #@story.build(:moderations)
    #@story.build(:sources)
    #@story.build(:images)
  end


  def update
    page = params[:page] || 1
    id = params[:id]
    @stories = Story.order(updated_at: :desc, created_at: :desc, title: :asc).try(:page, page)
    @story = Story.find(id) if Story.exists?(id)
    @topic = @story.try(:topics).try(:last)

    update_or_create_story(params)
  end


  def create
    update_or_create_story(params)
  end

  private

  def update_or_create_story params
    # TODO: assign topic to story
    # @story = Story.find_or_create_by!(story_params)
    topic_id = params[:topic]
    title = params[:story][:title]
    id = params[:id]
    @topic = Topic.find(topic_id) if Topic.exists?(id: topic_id)
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
        render "new"
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
      # if (@story.save)
      #   #redirect to success page
      # else
      #   #redirect to new action with errors
      # end

      # @story = Story.find(id)
      # @story.topics << @topic if !@story.topics.exists?(@topic)
      # #@story.try(:topics).try(:find, @topic)
      # m = Moderation.find_or_create_by!(moderation_params params)
      # @story.moderations << m
      #
      # #if @story.save
      # if @story.update(story_params params)
      #   redirect_to(@story)
      # else
      #   render "edit"
      # end
      # # if (@story.save)
      # #   #redirect to success page
      # # else
      # #   #redirect to new action with errors
      # # end
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

  def story_params
    #params.require(:story).permit(:title, :text, :topic_ids, :source_ids,  topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
    params.require(:story).permit(:title, :text, topic_ids: [], source_ids: [])
  end

  def moderation_params
    params.require(:story).permit(:title, :text) #todo: source_ids and topic_ids ?
  end

  # def story_params params
  #   params.require(:story).permit(:title, :text, :topic_ids=>[:id], :source_ids=>[:id])
  # end

  # def moderation_params params
  #   params.require(:story).permit(:title, :text, topic_ids:[], source_ids:[], :topic_ids=>{:id=>[]}, :source_ids=>{:id=>[]})
  # end

  def get_stories_and_topic_by_topic_id(topic_id, page)
    topic = Topic.find_by(id: topic_id) if Topic.exists?(id: topic_id)
    # @stories = Story.include(:topics).where(topics: {id:topic_id}).order(updated_at: :desc, title: :asc)
    stories = topic.try(:stories).try(:order, updated_at: :desc, title: :asc).try(:page, page) if topic.present?
    return stories, topic
  end
end
