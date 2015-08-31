ActiveAdmin.register Story do
  menu priority: 2, label: "Stories"
  sidebar "Story Details", only: [:show, :edit] do
    ul do
      li link_to "Sources", admin_sources_path(story)
      ul do
        if story.sources.present? && story.sources.any?
          story.sources.each do |source|
            li link_to "#{source.title} (#{source.created_at.strftime("%d/%m/%y %H:%M")})", admin_source_path(source)
          end
        else
          li "Source hasn't been added to the story: #{story.try(:title) || 'no story'}"
        end
      end
      li link_to "Topics", admin_topics_path()
      ul do
        if story.topics.present? && story.topics.any?
          story.topics.each do |topic|
            li link_to "#{topic.title} (#{topic.created_at.strftime("%d/%m/%y %H:%M")})", admin_topic_path(topic)
          end
        else
          li "Topic hasn't been added to the story: #{story.try(:title) || 'no story'}"
        end
      end

      li link_to "Moderations", admin_moderations_path()
      ul do
        if story.moderations.present? && story.moderations.any?
          story.moderations.each do |item|
            li link_to "#{item.title} (#{item.created_at.strftime("%d/%m/%y %H:%M")})", admin_moderation_path(item)
          end
        else
          li "Moderation hasn't been added to the story: #{story.try(:title) || 'no story'}"
        end
      end
    end
  end


  permit_params :title, :text, :stext, :is_approved, topic_ids: [], source_ids: [], topics_attributes: [:id, :title, :stext, :text, :is_approved, :_destroy], sources_attributes: [:id, :title, :url, :_destroy]

  controller do
    # This code is evaluated within the controller class

    def update
      id = params[:id]
      s = Story.find(id) if Story.exists?(id)
      s.update(story_params)
      #s.update_attributes(story_params)
      if s.save!
        redirect_to admin_story_path(s)
      else
        render "edit"
      end
    end

    def create
      id = params[:id]
      if !Story.exists?(id)
        s = Story.create!(story_params)
        #s = Story.new(story_params)
        #s.update_attributes(story_params)
        if s.save
          redirect_to admin_story_path(s)
        else
          render "new"
        end
      else
        render "new"
      end
    end

    private
    def story_params
      params.require(:story).permit(:title, :text, :stext, :is_approved, topic_ids: [], source_ids: [], topics_attributes: [:id, :title, :stext, :text, :is_approved, :_destroy], sources_attributes: [:id, :title, :url, :_destroy])
    end
  end


  index do
    selectable_column
    id_column
    column :title
    column :stext
    column :is_approved
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Story: #{story.try(:title) || 'no story'}" do
      f.input :title
      f.input :stext
      f.input :text
      f.input :is_approved
    end

    f.inputs "Sources" do
      #f.inputs 'Existing Sources.' do
      #  f.input :source_ids, as: :select, include_blank: true, multiple: true, selected: f.object.sources.map { |s| s.id }, collection: Source.all.map { |i| ["#{i.title} (#{i.created_at})", i.id] }
      #end

      #f.inputs 'New Sources.' do
        f.has_many :sources, allow_destroy: true, new_record: true do |p|
          p.input :title
          p.input :url, as: :url
          #p.input :id, label: 'Source', as: :select, multiple: false, selected: p.object.id, collection: Source.all.map { |i| ["#{i.title}:#{i.url}",i.id] }
          p.actions
        end
      #end
    end

    f.inputs 'Topics' do
      # f.inputs 'Existing Topics.' do
      #   f.input :topic_ids, as: :select, include_blank: true, multiple: true, selected: f.object.topics.map { |t| t.id }, collection: Topic.all.map { |i| ["#{i.title} (#{i.created_at})", i.id] }
      # end

      # f.inputs 'New Topics.' do
        f.input :topic_ids, as: :select, include_blank: true, multiple: true, selected: f.object.topics.map { |t| t.id }, collection: Topic.all.map { |i| ["#{i.title} (#{i.created_at})", i.id] } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
        # f.has_many :topics, allow_destroy: true, new_record: true do |p|
        #   p.input :id, label: 'Topic', as: :select, multiple: false, selected: p.object.id, collection: Topic.all.map { |i| [i.title, i.id] } #collection: Topic.all.map { |i| "#{i.title} (#{i.created_at})" } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
        #   # p.input :title
        #   # p.input :stext
        #   # p.input :text
        #   # p.input :is_approved, as: :radio
        #   p.actions
        # end
      # end
    end
    f.actions
  end

end

# ActiveAdmin.register Source do
#   belongs_to :story
# end
