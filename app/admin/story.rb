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

  permit_params :title, :text, :stext, :is_approved

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

end
#
# ActiveAdmin.register Source do
#   belongs_to :story
# end
