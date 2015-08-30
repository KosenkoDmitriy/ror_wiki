ActiveAdmin.register Moderation do
  menu priority: 1, label: "Moderation Queue"

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
  permit_params do
    permitted = [:title, :text, :stext, :is_approved]
    # permitted << :id if resource.Moderation
    # permitted
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


end
