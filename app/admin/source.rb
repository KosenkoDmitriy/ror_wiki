ActiveAdmin.register Source do
  # menu label: "Sources", parent: "Story"
  menu false

  permit_params :title, :url

  index do
    selectable_column
    id_column
    column :title
    column :url
    column :created_at
    column :updated_at
    actions
  end
end
