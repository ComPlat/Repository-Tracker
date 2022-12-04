# frozen_string_literal: true

class RequestStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:build).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_h
  end
end
