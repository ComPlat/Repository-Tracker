RSpec.describe "SPA" do
  it do
    visit "/"
    expect(page).to have_selector "h1", text: "Repository-Tracker"
  end

  describe "Table columns" do
    it do
      visit "/"
      expect(page).to have_text "ID"
    end

    it do
      visit "/"
      expect(page).to have_text "1"
    end

    it do
      visit "/"
      find(".ant-table-column-title", text: "ID").click
      expect(page).to have_text "1"
    end

    it do
      visit "/"
      find(".ant-table-column-title", text: "ID").click.click

      expect(page).to have_text "10000"
    end

    it do
      visit "/"
      expect(page).to have_text "From"
    end

    it do
      visit "/"
      expect(page).to have_text "To"
    end

    it do
      visit "/"
      expect(page).to have_text "Date/Time"
    end

    it do
      visit "/"
      expect(page).to have_text "Status"
    end

    it do
      visit "/"
      expect(page).to have_text "Data/Metadata"
    end

    it do
      visit "/"
      expect(page).to have_text "Tracker Number"
    end

    it do
      visit "/"
      expect(page).to have_text "Owner"
    end
  end
end
