class TrackingBuilder
  def initialize(params) = @params = params

  def build = @build ||= Tracking.new(attributes)

  def create! = build.save! && build

  private

  def attributes
    @attributes ||= {status:,
                     metadata:,
                     tracking_item:,
                     from_trackable_system:,
                     to_trackable_system:}
  end

  def status = @status ||= @params["status"]

  def metadata = @metadata ||= @params["metadata"]

  def tracking_item_name = @tracking_item_name ||= @params["tracking_item_name"]

  def from_trackable_system_name = @from_trackable_system_name ||= @params["from_trackable_system_name"]

  def to_trackable_system_name = @to_trackable_system_name ||= @params["to_trackable_system_name"]

  def tracking_item_owner_email = @tracking_item_owner_email ||= @params["tracking_item_owner_email"]

  def tracking_item = @tracking_item ||=
                        TrackingItem.find_or_create_by!(name: tracking_item_name, user:)

  def user
    User.find_by(email: tracking_item_owner_email, role: :user) ||
      User.create!(email: tracking_item_owner_email,
        name: tracking_item_owner_email,
        role: :user,
        password: SecureRandom.base64(12))
  end

  def from_trackable_system = @from_trackable_system ||=
                                TrackableSystem.find_by!(name: from_trackable_system_name)

  def to_trackable_system = @to_trackable_system ||=
                              TrackableSystem.find_by!(name: to_trackable_system_name)
end
