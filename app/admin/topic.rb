ActiveAdmin.register Topic do
  menu priority: 3, label: "Topics"

  # filter :is_approved
  filter :title
  filter :stext
  filter :text
  filter :date_time
  # filter :stories

  permit_params :date_time, :title, :text, :stext, :is_approved

  index do
    selectable_column
    id_column
    column :title
    column :stext
    # column :is_approved
    column :date_time
    # column :created_at
    # column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :date_time, as: :datetime_picker
      f.input :title
      f.input :stext, as: :text
      f.input :text, as: :text
      # f.input :is_approved
      f.actions
    end
  end

end
