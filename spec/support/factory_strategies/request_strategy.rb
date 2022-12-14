class RequestStrategy
  def initialize = @strategy = FactoryBot.strategy_by_name(:build).new

  delegate :association, to: :@strategy

  def result(evaluation) = @strategy.result(evaluation).to_h
end
