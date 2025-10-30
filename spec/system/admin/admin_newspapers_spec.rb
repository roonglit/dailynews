require 'rails_helper'

describe "Manage Admin Newspapers" do
  context "given an admin user with existing newspapers" do
    before { @newspapers = create_list(:newspaper, 1) }
    it "when admin press Newspapers button then navigate to mange newspapers correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar
      click_link_or_button "Newspapers"

      # system navigate to newspapers page correctly
      expect(page).to have_current_path(admin_newspapers_path)

      # system show newspaper title correctly
      expect(page).to have_content("Example Book")
    end

    it "when admin press trash button then remove newspaper correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar, press trash icon then remove newspaper correctly
      expect {
        click_link_or_button "Newspapers"
        find('.trash-icon').click
      }.to change(Newspaper, :count).from(1).to(0)

      # system navigate to newspaper page correctly
      expect(page).to have_current_path(admin_newspapers_path)

      # system show newspaper title correctly
      expect(page).not_to have_content("Example Book")
    end
  end

  context "given an admin user navigate to newspaper detail" do
    before { @newspapers = create_list(:newspaper, 1) }
    it "when admin eye button then navigate to newspaper detail correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar and press show icon
      click_link_or_button "Newspapers"
      find('.show-icon').click

      # system navigate to newspaper page correctly
      expect(page).to have_current_path(admin_newspaper_path(1))

      # system show newspaper title correctly
      expect(page).to have_content("Example Book")
    end

    it "when admin press back from newspaper detail then navigate back correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar, press show icon, press back then newspaper count not change
      expect {
        click_link_or_button "Newspapers"
        find('.show-icon').click
        click_link_or_button "Back to list"
      }.not_to change(Newspaper, :count)

      # system navigate to newspaper page correctly
      expect(page).to have_current_path(admin_newspapers_path)

      # system show newspaper title correctly
      expect(page).to have_content("Example Book")
    end

    it "when admin press delete newspaper from newspaper detail then delete and navigate back correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar, press show icon, press Delete then remove newspaper correctly
      expect {
        click_link_or_button "Newspapers"
        find('.show-icon').click
        click_link_or_button "Delete"
      }.to change(Newspaper, :count).from(1).to(0)

      # system navigate to newspaper page correctly
      expect(page).to have_current_path(admin_newspapers_path)

      # system show newspaper title correctly
      expect(page).not_to have_content("Example Book")
    end

    it "when admin press edit newspaper from newspaper detail then navigate to edit newspaper correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers on side bar, press show icon, press Edit
      click_link_or_button "Newspapers"
      find('.show-icon').click
      click_link_or_button "Edit"

      # system navigate to edit newspaper page correctly
      expect(page).to have_current_path(edit_admin_newspaper_path(1))

      # system show page title correctly
      expect(page).to have_content("Edit Newspaper")
    end
  end

  context "given an admin user navigate to edit newspaper" do
    before { @newspapers = create_list(:newspaper, 1) }
    it "when admin pencil button then navigate to edit newspaper correctly" do
      # login with admin account
      login_as_admin

      # admin press Newspapers button, then press pencil button
      click_link_or_button "Newspapers"
      find('.pencil-icon').click

      # system should navigate to edit newspaper page correctly
      expect(page).to have_current_path(edit_admin_newspaper_path(1))

      # system show page title correctly
      expect(page).to have_content("Edit Newspaper")

      # system should prefill newspaper title correctly
      expect(page).to have_field("newspaper_title", with: "Example Book")

      # system should prefill newspaper description correctly
      expect(page).to have_field("newspaper_description", with: "Description example")

      # system should prefill newspaper date correctly
      expect(page).to have_field("newspaper_published_at", with: Date.today)
    end
  end
end
