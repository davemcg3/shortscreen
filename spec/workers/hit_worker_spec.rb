require "rails_helper"

RSpec.describe HitWorker, type: :worker do
  describe "#perform" do
    let(:link){ FactoryBot.create(:link)}
    let(:time){ Time.zone.now.to_s }
    let(:user_agent){ 'abcd' }

    it 'updates the user agent' do
      subject.perform(link.id, time, user_agent)
      expect(link.reload.user_agents.keys).to include(user_agent)
    end

    it 'updates the day of the week' do
      subject.perform(link.id, time, user_agent)
      expect(link.reload.day_of_week.keys).to include(Time.parse(time).wday.to_s)
    end

    it 'updates the hour of the day' do
      subject.perform(link.id, time, user_agent)
      expect(link.reload.hour_of_day.keys).to include(Time.parse(time).hour.to_s)
    end

    it 'updates the use count' do
      subject.perform(link.id, time, user_agent)
      expect(link.reload.use_count).to eq(1)
    end
  end
end
