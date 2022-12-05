RSpec.describe "SPA" do
  it do
    visit "/"
    expect(page).to have_selector "h1", text: "Repository-Tracker"
  end

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
end
