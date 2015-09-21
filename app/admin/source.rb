ActiveAdmin.register Source do
  # menu label: "Sources", parent: "Story"
  menu false
  # conditionally show a custom controller scope

  permit_params :title, :url

  index do
    selectable_column
    id_column
    column :title
    column :url
    column :date_time
    # column :created_at
    # column :updated_at
    actions
  end
end
