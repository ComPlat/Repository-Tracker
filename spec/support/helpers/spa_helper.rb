module SpaHelper
  def login_with_wrong_credentials
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[1]/div/div[1]/div/div/div/div").click.fill_in(with: "notauser@example.com")
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[1]/div/div[2]/div/div/div/div").click.fill_in(with: "notapassword")
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[2]/div/div/div/div/div").click
  end

  def login_with_correct_credentials
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[1]/div/div[1]/div/div/div/div").click.fill_in(with: user.email)
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[1]/div/div[2]/div/div/div/div").click.fill_in(with: user.password)
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div[2]/div/div/div/div/div").click
  end

  def registration_new_user
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: "New User")
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: "newuser@exmaple.com")
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: "SecurePassword123-")
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[4]/div/div[2]/div/div/span/input").click.fill_in(with: "SecurePassword123-")
    click_button "Submit"
  end

  def registration_with_existing_user
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: user.name)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: user.email)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: user.password)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[4]/div/div[2]/div/div/span/input").click.fill_in(with: user.password)
    click_button "Submit"
  end

  def registration_password_not_valid
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: user.name)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: user.email)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: "notavalidpassword")
  end

  def registration_password_invalid_confirmation
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: user.name)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: user.email)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: user.password)
    find(:xpath, "/html/body/div/div/div[2]/div/div/form/div[4]/div/div[2]/div/div/span/input").click.fill_in(with: "#{user.password}test")
    click_button "Submit"
  end

  def column_selection_search(column, fill_with)
    first(".ant-table-filter-column", text: column).find(".ant-table-filter-trigger").click
    find(".ant-select-selection-overflow").click.fill_in(with: fill_with)
    first(".ant-select-item-option-content").click
  end

  def owner_name
    @owner_name ||= first(".ant-select-item-option-content").text
  end

  def close_notification
    find(".ant-notification-notice-close").click
  end

  def click_on_empty_space
    find(:xpath, "/html").click
  end

  def click_on_size_button(size)
    find(".ant-table-small")
    find(".ant-radio-group", text: size).click
  end
end
