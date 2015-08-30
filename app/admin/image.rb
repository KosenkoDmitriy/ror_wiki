ActiveAdmin.register Image do
  menu false
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

