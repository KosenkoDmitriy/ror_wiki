ActiveAdmin.register Topic do
  menu priority: 3, label: "Topics"

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
