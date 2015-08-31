ActiveAdmin.register Image do
  menu false

  permit_params :title, :text, :url, :path, :alt

  index do
    selectable_column
    id_column
    column :title
    column :text
    column :url
    column :path
    column :alt
    actions
  end
end

