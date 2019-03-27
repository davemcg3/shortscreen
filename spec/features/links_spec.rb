require 'rails_helper'
require 'sidekiq/testing'

feature 'Links', js: true do
  let(:link){ FactoryBot.create(:link) }

  scenario 'anyone can create a link' do
    visit new_link_path
    fill_in 'link[destination]', with: 'abcd'
    click_on 'Create Link'

    expect(Link.find_by_destination('abcd')).to eq(Link.last)
    expect(page.find('h2')).to have_text("Link #{Link.last.short_code}")
  end

  scenario 'any visited non-expired link is redirected' do
    redirect_link = Link.create(destination: "/admin/#{link.admin_code}")
    visit "/#{redirect_link.short_code}"
    expect(page.current_path).to eq("/admin/#{link.admin_code}")
  end

  scenario 'any visited expired link is redirected' do
    current_driver = Capybara.current_driver
    Capybara.current_driver = :rack_test

    redirect_link = Link.create(destination: "/admin/#{link.admin_code}")
    redirect_link.update!(expired_at: Time.zone.now)
    expect{ visit "/#{redirect_link.short_code}"}.to raise_exception(ActionController::RoutingError)

    Capybara.current_driver = current_driver
  end

  scenario 'any link can be expired with an admin code' do
    visit "/admin/#{link.admin_code}"
    expect(link.expired_at).to eq(nil)
    click_on 'Expire Link'
    expect(link.reload.expired_at).not_to eq(nil)
  end

  context 'without an admin password or session' do
    scenario 'an attempt to show all links is redirected to the new link page' do
      visit links_path
      expect(page.current_path).to eq("/links/new")
    end

    scenario 'an attempt to delete a link is redirected to the new link page' do
      current_driver = Capybara.current_driver
      Capybara.current_driver = :rack_test

      response = page.driver.delete destroy_link_path(admin_code: link.admin_code)
      expect(link.reload).to eq(link)
      expect(response.status).to eq(302)
      expect(response.location).to eq("http://www.example.com/links/new")

      Capybara.current_driver = current_driver
    end
  end

  context 'as an admin' do
    scenario 'with a password all links can be listed' do
      visit links_path(password: "12180 Millennium")
      expect(page.current_path).to eq("/links")
    end

    scenario 'with a valid session all links can be listed' do
      page.set_rack_session(authenticated: true)
      visit links_path
      expect(page.current_path).to eq("/links")
    end

    scenario 'any link can be deleted' do
      current_driver = Capybara.current_driver
      Capybara.current_driver = :rack_test
      page.set_rack_session(authenticated: true)

      page.driver.delete destroy_link_path(admin_code: link.admin_code)
      expect{link.reload}.to raise_exception(ActiveRecord::RecordNotFound)

      Capybara.current_driver = current_driver
    end

    scenario 'the user can logout' do
      page.set_rack_session(authenticated: true)
      visit '/logout'
      expect(page.current_path).to eq("/links/new")
      visit links_path
      expect(page.current_path).to eq("/links/new")
    end
  end
end
