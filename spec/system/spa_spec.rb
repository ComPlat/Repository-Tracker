RSpec.describe "SPA" do
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
        expect(page).to have_text "ELN"
      end

      it do
        first(".ant-table-column-title", text: "To").click
        expect(page).to have_text "nmrXiv"
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click
        expect(page).to have_text "01.01.1970 12:30.00"
      end

      it do
        first(".ant-table-column-title", text: "Status").click
        expect(page).to have_text "DRAFT"
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click
        expect(page).to have_text "id: 0, data: metadata for some data"
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click
        expect(page).to have_text "T221001-ERC-00"
      end
    end

    describe "Descending order" do
      it do
        first(".ant-table-column-title", text: "ID").click.click
        expect(page).to have_text "10000"
      end

      it do
        first(".ant-table-column-title", text: "From").click.click
        expect(page).to have_text "REPO"
      end

      it do
        first(".ant-table-column-title", text: "To").click.click
        expect(page).to have_text "REPO"
      end

      it do
        first(".ant-table-column-title", text: "Date/Time").click.click
        expect(page).to have_text "01.01.1970 12:30.00"
      end

      it do
        first(".ant-table-column-title", text: "Status").click.click
        expect(page).to have_text "SUBMITTED"
      end

      it do
        first(".ant-table-column-title", text: "Data/Metadata").click.click
        expect(page).to have_text "id: 9999, data: metadata for some data"
      end

      it do
        first(".ant-table-column-title", text: "Tracker Number").click.click
        expect(page).to have_text "T221001-ERC-09999"
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
