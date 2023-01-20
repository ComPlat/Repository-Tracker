module SpaHelper
  def login_with_wrong_credentials
    fill_in_email_input("notauser@example.com")
    fill_in_password_input("notapassword")
    click_button "Login"
  end

  def login_with_correct_credentials
    fill_in_email_input(user.email)
    fill_in_password_input(user.password)
    click_button "Login"
  end

  def registration_new_user
    registration_user("New User", "newuser@exmaple.com", "SecurePassword123-", "SecurePassword123-")
  end

  def registration_with_existing_user
    registration_user(user.name, user.email, user.password, user.password)
  end

  def registration_password_not_valid
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: user.name)
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: user.email)
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: "notavalidpassword")
  end

  def registration_password_invalid_confirmation
    click_button "Register"
    registration_user(user.name, user.email, user.password, "#{user.password}test")
    click_button "Submit"
  end

  def column_selection_search(column, content)
    first(".ant-table-filter-column", text: column).find(".ant-table-filter-trigger").click
    find(".ant-select-selection-overflow").click.fill_in(with: content)
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

  private

  def fill_in_email_input(content)
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div/div[1]/div/div/div/div").click.fill_in(with: content)
  end

  def fill_in_password_input(content)
    find(:xpath, "/html/body/div/div/div[1]/div/div[2]/form/div/div/div[2]/div/div/div/div").click.fill_in(with: content)
  end

  def registration_user(name, email, password, confirmation)
    click_button "Register"
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[1]/div/div[2]/div/div/input").click.fill_in(with: name)
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[2]/div/div[2]/div/div/input").click.fill_in(with: email)
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[3]/div/div[2]/div/div/span/input").click.fill_in(with: password)
    find(:xpath, "/html/body/div/div/div[2]/div/div/div/form/div[4]/div/div[2]/div/div/span/input").click.fill_in(with: confirmation)
    click_button "Submit"
  end
end
