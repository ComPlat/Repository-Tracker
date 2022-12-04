class TrackingBuilder
  def initialize(params)
    @params = params
  end

  def build
    @build ||= Tracking.new({
      from: @params["from"],
      to: @params["to"],
      status: @params["status"],
      metadata: @params["metadata"],
      user_id: @params["user_id"]
    })
  end

  def create!
    build.save!

    build
  end
end
