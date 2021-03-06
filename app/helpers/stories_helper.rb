module StoriesHelper

  def group_by_date_time items_orig
    default_topic = Topic.find_or_create_by(title: t("topic.no_topic"), is_approved: true)
    dt_items = []
    items_orig.map { |item| dt_items << {"date_time": item.try(:date_time).try(:strftime, "%b %Y"), "items":[]} }
    dt_items.uniq!

    dt_items.each do |dt_item|
      items_orig.each do |item|
        item_date_time = item.try(:date_time).try(:strftime, "%b %Y") || item.try(:updated_at).try(:strftime, "%b %Y")
        topic = item.try(:topics).try(:last) || default_topic
        # item_date_time_b_y = item.try(:date_time).try(:strftime, "%b %Y") || item.try(:updated_at).try(:strftime, "%b %Y")
        item_date_time_d_b_h_m = item.try(:date_time).try(:strftime, "%d %B %H:%M") || item.try(:updated_at).try(:strftime, "%d %B %H:%M")
        item_date_time_d_b = item.try(:date_time).try(:strftime, "%d %B") || item.try(:updated_at).try(:strftime, "%d %B")
        if dt_item.try(:[], :date_time) == item_date_time
          dt_item[:items] << {"item": item, "topic": topic, "dt":item_date_time_d_b, "dt_full": item_date_time_d_b_h_m}
        end
      end
    end

    return dt_items
  end

  def stext_or_text stext, text, size
    result = stext
    if result.blank?
      if text.present?
        result = text.truncate(size||150, omission: '...')
      else

        # result = t(:none)
      end
    end

    return result.try(:html_safe)
  end

  def date_time_without_time dt
    return dt.try(:strftime, "%d %B")
  end
end
