ActiveAdmin.register Story do
  menu priority: 2, label: "Stories"
  # sidebar "Story Details", only: [:show, :edit] do
  #   ul do
  #     li link_to "Sources",    admin_story_sources_path(story)
  #   end
  # end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  permit_params :title, :text, :stext, :is_approved, topic_ids: [], source_ids: []

  controller do
    # This code is evaluated within the controller class

    def update
      id=params[:id]
      s=Story.find(id) if Story.exists?(id)
      s.update(story_params)
      s.update_attributes(story_params)
      if s.save!
        redirect_to admin_story_path(s)
      else
        render "edit"
      end

      # Instance method
    end

    private
    def story_params
      params.require(:story).permit(:title, :text, :stext, :is_approved, topic_ids: [], source_ids: [], topics_attributes:[], sources_attributes:[])
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
    f.inputs "Story Details" do
      f.input :title
      f.input :stext
      f.input :text
      f.input :is_approved
    end

    f.inputs 'Sources.' do
      f.input :source_ids, as: :select, multiple: true, selected:f.object.sources.map{|s| s.id } , collection: Source.all.map { |i| ["#{i.title} (#{i.created_at})", i.id] } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
      # f.has_many :sources, new_record: true do |p|
      #   #p.input :title
      #   # or maybe even
      #   p.input :id, label: 'Source', as: :select, multiple: false, selected: p.object.id, collection: Source.all.map { |i| ["#{i.title}:#{i.url}",i.id] }
      #   p.actions
      # end
    end

    f.inputs 'Topics.' do
      f.input :topic_ids, as: :select, multiple: true, selected:f.object.topics.map{|t| t.id}, collection: Topic.all.map { |i| ["#{i.title} (#{i.created_at})", i.id] } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
      # f.has_many :topics, new_record: true do |p|
      #   p.input :id, label: 'Topic', as: :select, multiple: false, selected: p.object.id, collection: Topic.all.map { |i| [i.title, i.id] } #collection: Topic.all.map { |i| "#{i.title} (#{i.created_at})" } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
      #   p.actions
      # end
    end

    # f.inputs 'Topics.' do
    #   f.input :topics, as: :select, multiple: true, collection: Topic.all.map { |i| "#{i.title} (#{i.created_at})" } #, options_for_select(["Page", "Organization", "Promotion"], p.object)
    # end

    f.actions
  end

end
#
# ActiveAdmin.register Source do
#   belongs_to :story
# end
