require "rails_helper"

RSpec.describe AuthsController, type: :routing do
  describe "routing" do
    it "routes to #logout" do
      expect(:get => "/logout").to route_to("auths#logout")
    end
  end
end
