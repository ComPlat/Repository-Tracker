RSpec.describe "SPA" do
  include SpaHelper

  let(:user) { create(:user, :with_required_attributes_as_user) }
  let(:tracking_item) { create(:tracking_item, :with_required_attributes, user:) }
  let(:trackings) do
    [create(:tracking, :with_required_attributes, tracking_item:,
      from_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies,
        name: "chemotion_electronic_laboratory_notebook"),
      to_trackable_system: create(:trackable_system, :with_required_attributes, :with_required_dependencies,
        name: "radar4kit"))] +
      create_list(:tracking, 99, :with_required_attributes, :with_required_dependencies, tracking_item:)
  end
  let(:access_token) { create(:doorkeeper_access_token, :with_required_dependencies) }
  # HINT: Database has UTC timestamp, we format it to format used in frontend and zone used on machine (like frontend).
  let(:time) { trackings.map { |tracking| tracking.date_time.in_time_zone(Time.now.getlocal.zone).strftime("%d.%m.%Y, %H:%M:%S") }.min }

  before do
    # HINT: We use CSRF protection, which is switched off in test environments by default
    ActionController::Base.allow_forgery_protection = true

    freeze_time

    access_token
    trackings
    time
  end

  after do
    unfreeze_time
    ActionController::Base.allow_forgery_protection = false
  end

  describe "h1" do
    before do
      visit "/"
    end

    it do
      expect(page).to have_selector "h1", text: "Repository-Tracker"
    end
  end

  describe "Table columns" do
    before do
      visit "/"
    end

    it do
      expect(page).to have_content "ID"
    end

    it do
      expect(page).to have_content "From"
    end

    it do
      expect(page).to have_content "To"
    end

    it do
      expect(page).to have_content "Date/Time"
    end

    it do
      expect(page).to have_content "Status"
    end

    it do
      expect(page).to have_content "Data/Metadata"
    end

    it do
      expect(page).to have_content "Tracker Number"
    end

    it do
      expect(page).to have_content "Owner"
    end
  end

  describe "Failed login" do
    before do
      visit "/"
      login_with_wrong_credentials
    end

    it { expect(page).to have_content("Login failed", wait: 5) }
    it { expect(page).to have_content("The account data does not exist.", wait: 5) }
  end

  describe "Register" do
    context "when registration is successful" do
      before do
        visit "/"
        registration_new_user
      end

      it { expect(page).to have_content("Registration successful", wait: 5) }
      it { expect(page).to have_content("You have successfully signed up. You will be redirected to the main page.", wait: 5) }
    end

    context "when registration is successful and user can login" do
      before do
        visit "/"
        registration_new_user
        sleep 3
        login_with_correct_credentials
        close_notification
      end

      it { expect(page).to have_content(trackings.pluck(:id).min, wait: 5) }
    end

    context "when email is already taken" do
      before do
        visit "/"
        registration_with_existing_user
      end

      it { expect(page).to have_content("Registration unsuccessful", wait: 5) }
      it { expect(page).to have_content("E-Mail has already been taken", wait: 5) }
    end

    context "when password has not a valid format" do
      before do
        visit "/"
        registration_password_not_valid
      end

      it { expect(page).to have_content("Password must be at least 6 characters long, have at least 1 number, 1 uppercase letter and 1 special character (@$!%*?&-)", wait: 5) }
    end

    context "when password and confirmation of password do NOT match" do
      before do
        visit "/"
        registration_password_invalid_confirmation
      end

      it { expect(page).to have_content("The two passwords that you entered do not match!", wait: 5) }
    end
  end

  describe "Buttons to sort the items in a certain order" do
    before do
      visit "/"
      login_with_correct_credentials
      close_notification
    end

    describe "Ascending order" do
      it do
        first(".ant-table-column-title", text: "ID").click
        expect(page).to have_content(trackings.pluck(:id).min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "From").click
        expect(page).to have_content(trackings.map { |tracking| tracking.from_trackable_system.name }.min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "To").click
        expect(page).to have_content(trackings.map { |tracking| tracking.to_trackable_system.name }.min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click
        expect(page).to have_content(time, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Status").click
        expect(page).to have_content(trackings.pluck(:status).min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click
        expect(page).to have_content(trackings.map { |tracking| tracking.metadata.to_json }.min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click
        expect(page).to have_content(trackings.map { |tracking| tracking.tracking_item.name }.min, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Owner").click
        expect(page).to have_content(trackings.map { |tracking| tracking.tracking_item.user.name }.min, wait: 5)
      end
    end

    describe "Descending order" do
      it do
        first(".ant-table-column-title", text: "ID").click.click
        expect(page).to have_content(trackings.pluck(:id).max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "From").click.click
        expect(page).to have_content(trackings.map { |tracking| tracking.from_trackable_system.name }.max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "To").click.click

        expect(page).to have_content(trackings.map { |tracking| tracking.to_trackable_system.name }.max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click.click
        expect(page).to have_content(time, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Status").click.click
        expect(page).to have_content(trackings.pluck(:status).max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click.click
        expect(page).to have_content(trackings.map { |tracking| tracking.metadata.to_json }.max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click.click
        expect(page).to have_content(trackings.map { |tracking| tracking.tracking_item.name }.max, wait: 5)
      end

      it do
        first(".ant-table-column-title", text: "Owner").click.click
        expect(page).to have_content(trackings.map { |tracking| tracking.tracking_item.user.name }.max, wait: 5)
      end
    end
  end

  describe "Column search" do
    before do
      visit "/"
      login_with_correct_credentials
      close_notification
    end

    context "when search for 'chemotion_electronic_laboratory_notebook' in 'From' column" do
      before do
        column_selection_search("From", "chemotion_electronic_laboratory_notebook")
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[2]")) do
          expect(page).to have_content("chemotion_electronic_laboratory_notebook", wait: 5)
        end
      end
    end

    context "when search for 'radar4kit' in 'To' column" do
      before do
        column_selection_search("To", "radar4kit")
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[3]")) do
          expect(page).to have_content("radar4kit", wait: 5)
        end
      end
    end

    context "when search for 'draft' in 'Status' column" do
      before do
        column_selection_search("Status", "draft")
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[5]")) do
          expect(page).to have_content("draft", wait: 5)
        end
      end
    end

    context "when search for 'name1' in 'Tracker Number' column" do
      before do
        column_selection_search("Tracker Number", "name1")
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[7]")) do
          expect(page).to have_content("name1", wait: 5)
        end
      end
    end

    context "when search for 'chemotion_electronic_laboratory_notebook', 'radar4kit', 'draft' and 'name1' together" do
      before do
        column_selection_search("From", "chemotion_electronic_laboratory_notebook")
        column_selection_search("To", "radar4kit")
        column_selection_search("Status", "draft")
        column_selection_search("Tracker Number", "name1")
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[2]")) do
          expect(page).to have_content("chemotion_electronic_laboratory_notebook", wait: 5)
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[3]")) do
          expect(page).to have_content("radar4kit", wait: 5)
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[5]")) do
          expect(page).to have_content("draft", wait: 5)
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[7]")) do
          expect(page).to have_content("name1", wait: 5)
        end
      end
    end

    context "when first owner is selected for search" do
      before do
        first(".ant-table-filter-column", text: "Owner").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click
        owner_name
        first(".ant-select-item-option-content").click
        click_on_empty_space
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[8]")) do
          expect(page).to have_content(owner_name, wait: 5)
        end
      end
    end
  end

  describe "Buttons to change table size" do
    before do
      visit "/"
    end

    it do
      click_on_size_button("Middle")

      expect(page).to have_selector(".ant-table-middle", wait: 5)
    end

    it do
      click_on_size_button("Large")

      expect(page).to have_none_of_selectors(".ant-table-small", wait: 5)
    end
  end

  describe "Pagination" do
    before do
      visit "/"
      login_with_correct_credentials
      close_notification
    end

    describe "Pagination items" do
      it do
        find(".ant-pagination-item-1").click
        find(".ant-pagination-item-2").click

        expect(page).to have_content(trackings[10].id, wait: 5)
      end

      it do
        find(".ant-pagination-item-1").click
        find(".ant-pagination-item-ellipsis").click
        find(".ant-pagination-item-8").click

        expect(page).to have_content(trackings[70].id, wait: 5)
      end

      it do
        find(".ant-pagination-item-1").click
        find(".ant-pagination-next").click

        expect(page).to have_content(trackings[10].id, wait: 5)
      end

      it do
        find(".ant-pagination-item-1").click
        find(".ant-pagination-item-2").click
        find(".ant-pagination-prev").click

        expect(page).to have_content(trackings.pluck(:id).min, wait: 5)
      end
    end

    describe "Number of items per page" do
      before do
        find(".ant-select-selector", text: "10 / page").click
      end

      it do
        find(".ant-select-item-option-content", text: "20 / page").click
        find(".ant-pagination-item-1").click
        scroll_to(:bottom)

        expect(page).to have_content(trackings[19].id, wait: 5)
      end

      it do
        find(".ant-select-item-option-content", text: "50 / page").click
        find(".ant-pagination-item-1").click
        scroll_to(:bottom)

        expect(page).to have_content(trackings[49].id, wait: 5)
      end

      it do
        find(".ant-select-item-option-content", text: "100 / page").click
        find(".ant-pagination-item-1").click
        scroll_to(:bottom)

        expect(page).to have_content(trackings[99].id, wait: 5)
      end
    end
  end
end
