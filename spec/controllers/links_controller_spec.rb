require "rails_helper"
require 'sidekiq/testing'

RSpec.describe LinksController, type: :controller do
  describe("#visit") do
    let(:link){ FactoryBot.create(:link) }

    it "should redirect with 301" do
      get :visit, params: { short_code: link.short_code }
      expect(response.code).to eq("301")
    end
  end
end
