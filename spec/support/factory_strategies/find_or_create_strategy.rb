class FindOrCreateStrategy
  delegate :association, to: :build_strategy

  def result(evaluation)
    @evaluation = evaluation
    @attributes = evaluation.object.attributes
    find || create!
  end

  private

  def find = @evaluation.object.class.find_by shared_attributes

  def create! = FactoryBot.strategy_by_name(:create).new.result(@evaluation)

  # HINT: This handles edge case when attribute has different name in initializer of model
  #       than in its initialized attributes.
  #       e.g. a Devise User Model takes a password, but has an encrypted_password
  #       (which has not same value because its encrypted).
  #       So we filter out these attributes, because they would disrupt finding record.
  def shared_attributes = @evaluation.hash.filter { |key, _value| @attributes.key?(key.to_s) }

  def build_strategy = @build_strategy ||= FactoryBot.strategy_by_name(:build).new
end
