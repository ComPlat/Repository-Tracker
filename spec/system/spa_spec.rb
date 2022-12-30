RSpec.describe "SPA" do
  let(:tracking1) {
    create(:tracking, :with_required_dependencies, :with_required_attributes,
      from_trackable_system: create(:trackable_system, :with_required_attributes,
        name: "chemotion_electronic_laboratory_notebook"),
      to_trackable_system: create(:trackable_system, :with_required_attributes,
        name: "radar4kit"))
  }
  let(:trackings) {
    create_list(:tracking, 99, :with_required_dependencies, :with_required_attributes)
  }
  let(:time) { (trackings.last.date_time + Time.zone.now.gmt_offset).strftime("%d.%m.%Y, %H:%M:%S") }

  before do
    freeze_time

    tracking1
    trackings
    time
  end

  after do
    unfreeze_time
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
      expect(page).to have_text "ID"
    end

    it do
      expect(page).to have_text "1"
    end

    it do
      expect(page).to have_text "From"
    end

    it do
      expect(page).to have_text "To"
    end

    it do
      expect(page).to have_text "Date/Time"
    end

    it do
      expect(page).to have_text "Status"
    end

    it do
      expect(page).to have_text "Data/Metadata"
    end

    it do
      expect(page).to have_text "Tracker Number"
    end

    it do
      expect(page).to have_text "Owner"
    end
  end

  describe "Buttons to sort the items in a certain order" do
    before do
      visit "/"
    end

    describe "Ascending order" do
      it do
        first(".ant-table-column-title", text: "ID").click
        expect(page).to have_text "1"
      end

      it do
        first(".ant-table-column-title", text: "From").click
        expect(page).to have_text "chemotion_electronic_laboratory_notebook"
      end

      it do
        first(".ant-table-column-title", text: "To").click
        expect(page).to have_text "chemotion_electronic_laboratory_notebook"
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click
        expect(page).to have_text time
      end

      it do
        first(".ant-table-column-title", text: "Status").click
        expect(page).to have_text "draft"
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click
        expect(page).to have_text "{\"key\":\"value1\"}"
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click
        expect(page).to have_text "name1"
      end

      it do
        first(".ant-table-column-title", text: "Owner").click
        expect(page).to have_text "name1"
      end
    end

    describe "Descending order" do
      it do
        first(".ant-table-column-title", text: "ID").click.click
        expect(page).to have_text "100"
      end

      it do
        first(".ant-table-column-title", text: "From").click.click
        expect(page).to have_text "radar4kit"
      end

      it do
        first(".ant-table-column-title", text: "To").click.click
        expect(page).to have_text "radar4kit"
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click.click
        expect(page).to have_text time
      end

      it do
        first(".ant-table-column-title", text: "Status").click.click
        expect(page).to have_text "draft"
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click.click
        expect(page).to have_text "{\"key\":\"value100\"}"
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click.click
        expect(page).to have_text "name100"
      end

      it do
        first(".ant-table-column-title", text: "Owner").click.click
        expect(page).to have_text "name100"
      end
    end
  end

  describe "Column search" do
    before do
      visit "/"
    end

    context "when search for 'chemotion_electronic_laboratory_notebook' in 'From' column" do
      before do
        first(".ant-table-filter-column", text: "From").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "chemotion_electronic_laboratory_notebook")
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[2]")) do
          expect(page).to have_content "chemotion_electronic_laboratory_notebook"
        end
      end
    end

    context "when search for 'radar4kit' in 'To' column" do
      before do
        first(".ant-table-filter-column", text: "To").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "radar4kit")
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[3]")) do
          expect(page).to have_content "radar4kit"
        end
      end
    end

    context "when search for 'draft' in 'Status' column" do
      before do
        first(".ant-table-filter-column", text: "Status").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "draft")
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[5]")) do
          expect(page).to have_content "draft"
        end
      end
    end

    context "when search for 'name1' in 'Tracker Number' column" do
      before do
        first(".ant-table-filter-column", text: "Tracker Number").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "name1")
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[7]")) do
          expect(page).to have_content "name1"
        end
      end
    end

    context "when search for 'chemotion_electronic_laboratory_notebook', 'radar4kit', 'draft' and 'name1' together" do
      before do
        first(".ant-table-filter-column", text: "From").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "chemotion_electronic_laboratory_notebook")
        first(".ant-select-item-option-content").click
        first(".ant-table-filter-column", text: "To").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "radar4kit")
        first(".ant-select-item-option-content").click
        first(".ant-table-filter-column", text: "Status").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "draft")
        first(".ant-select-item-option-content").click
        first(".ant-table-filter-column", text: "Tracker Number").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click.fill_in(with: "name1")
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[2]")) do
          expect(page).to have_content "chemotion_electronic_laboratory_notebook"
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[3]")) do
          expect(page).to have_content "radar4kit"
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[5]")) do
          expect(page).to have_content "draft"
        end
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[7]")) do
          expect(page).to have_content "name1"
        end
      end
    end

    context "when first owner is selected for search" do
      let(:owner_name) { first(".ant-select-item-option-content").text }

      before do
        visit "/"
        first(".ant-table-filter-column", text: "Owner").find(".ant-table-filter-trigger").click
        find(".ant-select-selection-overflow").click
        owner_name
        first(".ant-select-item-option-content").click
        find(:xpath, "/html").click
      end

      it do
        within(find(:xpath, "//table/tbody/tr[1]/td[8]")) do
          expect(page).to have_content owner_name
        end
      end
    end
  end

  describe "Buttons to change table size" do
    before do
      visit "/"
    end

    it do
      find(".ant-table-small")
      find(".ant-radio-group", text: "Middle").click

      expect(page).to have_selector(".ant-table-middle")
    end

    it do
      find(".ant-table-small")
      find(".ant-radio-group", text: "Large").click

      expect(page).to have_none_of_selectors(".ant-table-small")
    end
  end

  describe "Pagination" do
    before do
      visit "/"
    end

    describe "Pagination items" do
      it do
        find(".ant-pagination-item-2").click

        expect(page).to have_text "11"
      end

      it do
        find(".ant-pagination-item-ellipsis").click
        find(".ant-pagination-item-8").click

        expect(page).to have_text "71"
      end

      it do
        find(".ant-pagination-next").click

        expect(page).to have_text "11"
      end

      it do
        find(".ant-pagination-item-2").click
        find(".ant-pagination-prev").click

        expect(page).to have_text "1"
      end
    end

    describe "Number of items per page" do
      before do
        find(".ant-select-selector", text: "10 / page").click
      end

      it do
        find(".ant-select-item-option-content", text: "20 / page").click

        expect(page).to have_text "20"
      end

      it do
        find(".ant-select-item-option-content", text: "50 / page").click

        expect(page).to have_text "50"
      end

      it do
        find(".ant-select-item-option-content", text: "100 / page").click

        expect(page).to have_text "100"
      end
    end
  end
end
