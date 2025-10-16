module AuthHelper
  def login_as_user(user = nil)
    @user = user || create(:member)

    # user clicks on the avatar icon to sign in
    visit root_path
    find('.user-avatar').click
    click_link 'Sign in here'

    # user fills in email and password, and sign in
    fill_in 'email', with: @user.email
    fill_in 'password', with: 'password123'
    click_link_or_button 'SIGN IN'

    # user should see a welcome message
    expect(page).to have_content('Signed in successfully.')
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :system
end
