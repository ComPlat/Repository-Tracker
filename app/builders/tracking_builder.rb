class TrackingBuilder
  def initialize(params) = @params = params

  def build = @build ||= Tracking.new(attributes)

  def create! = build.save! && build

  private

  def attributes
    @attributes ||= {status:,
                     metadata:,
                     tracking_item_id:,
                     from_trackable_system_id:,
                     to_trackable_system_id:}
  end

  def status = @status ||= @params["status"]

  def metadata = @metadata ||= @params["metadata"]

  def tracking_item_id
    @tracking_item_id ||= if @params["tracking_item_name"].nil?
      TrackingItem.create!(name: "tracking_item_name", user:).id
    else
      TrackingItem.find_or_create_by!(name: @params["tracking_item_name"], user:).id
    end
  end

  def user
    User.find_by(email: @params["tracking_item_owner_email"], role: :user) ||
      User.create!(email: @params["tracking_item_owner_email"],
        name: @params["tracking_item_owner_email"],
        role: :user, password: SecureRandom.base64(12))
  end

  def from_trackable_system_id = @from_trackable_system_id ||=
                                   TrackableSystem.find_or_create_by!(name: @params["from_trackable_system_name"]).id

  def to_trackable_system_id = @to_trackable_system_id ||=
                                 TrackableSystem.find_or_create_by!(name: @params["to_trackable_system_name"]).id
end
