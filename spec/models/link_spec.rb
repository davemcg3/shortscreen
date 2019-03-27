require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:destination) }

    it 'sets short code and admin code automatically' do
      link = Link.create(destination: 'abcd')
      expect(link.short_code).not_to be_nil
      expect(link.admin_code).not_to be_nil
    end
  end

  describe '#active' do
    it 'scopes links to non-expired links' do
      FactoryBot.create_list(:link, 3)
      Link.last.update(expired_at: Time.zone.now)
      expect(Link.active.count).to eq(2)
    end
  end
end
