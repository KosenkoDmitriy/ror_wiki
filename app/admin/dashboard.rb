ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    #Here is an example of a simple dashboard with columns and panels.
    columns do
      column do
        panel "Info" do
          para "Welcome to Mattnhew Wiki."
        end
      end
    end

    columns do
      column do
        panel "Recent stories of the Moderation Queue" do
          table do
            th t("activerecord.models.Moderation.other")
            th t("activerecord.attributes.moderation.stext")
            th t("activerecord.attributes.moderation.date_time")
            # th "created date"
            # th "updated date"
            Moderation.last(30).reverse.map do |post|
              tr
              td link_to(post.title, admin_moderation_path(post))
              td post.stext
              td post.date_time
              # td post.created_at
              # td post.updated_at
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Stories" do
          ul do
            Story.last(10).reverse.map do |post|
              li link_to(post.title, admin_story_path(post))
            end
          end
        end
      end

      column do
        panel "Recent Topics" do
          ul do
            Topic.last(10).reverse.map do |post|
              li link_to(post.title, admin_topic_path(post))
            end
          end
        end
      end
    end

  end # content
end

# disable comments

# # For the entire application:
# ActiveAdmin.setup do |config|
#   config.comments = false
# end
#
# For a namespace:
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.comments = false
  end
end

# ActiveAdmin.register Image do
#   config.comments = false
# end
#
# ActiveAdmin.register Story do
#   config.comments = false
# end