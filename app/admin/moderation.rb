ActiveAdmin.register Moderation do
  menu priority: 1, label: "Moderation Queue"

  # permit_params do
  #   permitted = [:title, :text, :stext, :is_approved, topic_ids: [], source_ids: [], topics_attributes: [:id, :title, :stext, :text, :is_approved, :_destroy], sources_attributes: [:id, :title, :url, :_destroy]]
  #   # permitted << :id if resource.Moderation
  #   # permitted
  # end

  permit_params :title, :text, :stext, :date_time, :is_approved, topic_ids: [], source_ids: [], topics_attributes: [:id, :title, :stext, :text, :is_approved, :_destroy], sources_attributes: [:id, :title, :url, :_destroy]


  sidebar "Story Details", only: [:show, :edit] do
    ul do
      li moderation.story.present? ? link_to("Story", admin_moderation_path(moderation.try(:story))) : "Story is not found (so need to create a new story from this moderation)"
      li link_to "Sources", admin_moderation_path(moderation)
      ul do
        if moderation.sources.present? && moderation.sources.any?
          moderation.sources.each do |source|
            li link_to "#{source.title} (#{source.updated_at.strftime("%d/%m/%y %H:%M")})", admin_source_path(source)
          end
        else
          li "Source hasn't been added to the story: #{moderation.try(:title) || ''}"
        end
      end
      li link_to "Topics", admin_topics_path()
      ul do
        if moderation.topics.present? && moderation.topics.any?
          moderation.topics.each do |topic|
            li link_to "#{topic.title} (#{topic.date_time.strftime("%d/%m/%y %H:%M")})", admin_topic_path(topic)
          end
        else
          li "Topic hasn't been added to the story: #{moderation.try(:title) || ''}"
        end
      end
    end
  end

  controller do
    # This code is evaluated within the controller class

    def update
      id = params[:id]
      s = Moderation.find(id) if Moderation.exists?(id)
      s.update(story_params)
      #s.update_attributes(story_params)
      if s.save!
        redirect_to admin_moderation_path(s)
      else
        render "edit"
      end
    end

    def create
      id = params[:id]
      if !Moderation.exists?(id)
        s = Moderation.new(story_params)
        s.update_attributes(story_params)
        if s.save
          redirect_to admin_moderation_path(s)
        else
          render "new"
        end
      else
        render "new"
      end
    end

    private
    def story_params
      params.require(:moderation).permit(:title, :text, :stext, :date_time, :is_approved, topic_ids: [], source_ids: [], topics_attributes: [:id, :title, :stext, :text, :is_approved, :_destroy], sources_attributes: [:id, :title, :url, :_destroy])
    end
  end


  index do
    selectable_column
    id_column
    column :title
    column :stext
    column :is_approved
    column :date_time
    # column :created_at
    # column :updated_at
    actions
  end

  form do |f|
    f.inputs "Story: #{moderation.try(:title) || ''}" do
      f.input :title
      f.input :stext, as: :text, height:100
      f.input :text, as: :text
      f.input :date_time, as: :datetime_picker
      f.input :is_approved
    end

    f.inputs 'Sources' do
      #f.inputs 'Existing Sources' do
      #  f.input :source_ids, as: :select, include_blank: true, multiple: true, selected: f.object.sources.map { |s| s.id }, collection: Source.all.map { |i| ["#{i.title} (#{i.date_time})", i.id] }
      #end

      #f.inputs 'New Sources' do
        f.has_many :sources, allow_destroy: true, new_record: true do |p|
          p.input :title
          p.input :url, as: :url
          #p.input :id, label: 'Source', as: :select, multiple: false, selected: p.object.id, collection: Source.all.map { |i| ["#{i.title}:#{i.url}",i.id] }
          p.actions
        end
      #end
    end

    f.inputs 'Topics' do
      # f.inputs 'Existing Topics' do
        f.input :topic_ids, as: :select, include_blank: true, multiple: true, selected: f.object.topics.map { |t| t.id }, collection: Topic.all.map { |i| ["#{i.title} (#{i.date_time})", i.id] }
      # end

      # f.inputs 'New Topics' do
      #   # f.input :topic_ids, as: :select, include_blank: true, multiple: true, selected: f.object.topics.map { |t| t.id }, collection: Topic.all.map { |i| ["#{i.title} (#{i.date_time})", i.id] } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
      #   f.has_many :topics, allow_destroy: true, new_record: true do |p|
      #     # p.input :id, label: 'Topic', as: :select, multiple: false, selected: p.object.id, collection: Topic.all.map { |i| [i.title, i.id] } #collection: Topic.all.map { |i| "#{i.title} (#{i.date_time})" } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
      #     p.input :title
      #     p.input :stext
      #     p.input :text
      #     p.input :is_approved, as: :radio
      #     p.actions
      #   end
      # end
    end
    f.actions
  end

end
