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

  def login_new_user
    fill_in_email_input("newuser@example.com")
    fill_in_password_input("SecurePassword123-")
    click_button "Login"
  end

  def registration_new_user = registration_user("New User", "newuser@example.com", "SecurePassword123-", "SecurePassword123-")

  def registration_with_existing_user = registration_user(user.name, user.email, user.password, user.password)

  def registration_password_not_valid
    click_button "Register"
    find_by_id("nest-messages_name").click.fill_in(with: user.name)
    find_by_id("nest-messages_email").click.fill_in(with: user.email)
    find_by_id("nest-messages_password").click.fill_in(with: "notavalidpassword")
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

  def owner_name = @owner_name ||= first(".ant-select-item-option-content").text

  def close_notification = find(".ant-notification-notice-close").click

  def click_on_empty_space = find(:xpath, "/html").click

  def click_on_size_button(size)
    find(".ant-table-small")
    find(".ant-radio-group", text: size).click
  end

  def confirm_user_by_email = visit confirmation_link

  def confirm_with_invalid_confirmation_link = visit "/users/confirmation?confirmation_token=notavalidconfirmationtoken"

  private

  def fill_in_email_input(email) = find_by_id("normal_login_email").click.fill_in(with: email)

  def fill_in_password_input(password) = find_by_id("normal_login_password").click.fill_in(with: password)

  def registration_user(name, email, password, confirmation)
    click_button "Register"
    find_by_id("nest-messages_name").click.fill_in(with: name)
    find_by_id("nest-messages_email").click.fill_in(with: email)
    find_by_id("nest-messages_password").click.fill_in(with: password)
    find_by_id("nest-messages_confirm").click.fill_in(with: confirmation)
    click_button "Submit"
  end

  def confirmation_email = ActionMailer::Base.deliveries.last

  def confirmation_html = Nokogiri::HTML(confirmation_email.body.raw_source)

  def confirmation_link
    # HINT: We just want the request uri because test environment host is "www.example.com" but Capybara tests on "localhost"
    URI.parse(confirmation_html.at("a:contains('Confirm my account')")["href"]).request_uri
  end
end
