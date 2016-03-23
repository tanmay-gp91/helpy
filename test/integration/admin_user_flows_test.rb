require 'integration_test_helper'
include Warden::Test::Helpers

class AdminUserFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in("admin@test.com")
  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.use_default_driver
  end

  test "an admin should be able to view a user profile and edit that user" do

    first(".user-link").click
    assert page.has_content?('Scott Miller')
    assert page.has_content?('BIO')
    assert page.has_content?('CONTACT')
    assert page.has_content?('SOCIAL')

    click_on "Edit"
    assert page.has_css?('.checkbox-inline')

    #Edit user
    fill_in("user_name", with: 'Scott Miller (edited)')
    fill_in("user_company", with: '(edited)')
    fill_in("user_city", with: '(edited)')
    click_on "Save"

    assert page.has_content?('Scott Miller (Edited)')

  end

end
