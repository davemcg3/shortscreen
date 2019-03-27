class HitWorker
  include Sidekiq::Worker

  def perform(id, hit_at, ua)
    hit_at = Time.parse(hit_at)
    link = Link.find(id)
    link.with_lock do
      # these aren't really necessary, just proof-of-concepting for my production shortener :)
      update_json_column(link.user_agents, ua)
      update_json_column(link.day_of_week, hit_at.wday.to_s)
      update_json_column(link.hour_of_day, hit_at.hour.to_s)

      link.update(use_count: (link.use_count + 1))
    end
  end

  private

    def update_json_column(column, key)
      if column[key].present?
        column[key] = column[key] + 1
      else
        column[key] = 1
      end
    end
end
