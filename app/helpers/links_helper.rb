module LinksHelper
  def expired_at
    if @link.id.nil?
      return
    elsif @link.expired_at.nil?
      render 'links/expire_button'
    else
      render 'links/expire_info'
    end
  end

  def analytics_value(method, default_return="N/A")
    sorted_values = @link.public_send(method).sort_by {|_key, value| value}.to_h
    return default_return unless sorted_values.present?
    case method
    when :day_of_week
      Date::DAYNAMES[sorted_values.first[0].to_i]
    end
  end
end
