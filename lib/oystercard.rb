# frozen_string_literal: true

class Oystercard
  attr_reader :balance

  MAX_LIMIT = 90
  MIN_LIMIT = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Cannot top-up #{amount}, goes over the limit of £#{MAX_LIMIT}" if limit?(amount)

    @balance += amount
  end

  def limit?(amount)
    (amount + @balance) > MAX_LIMIT
  end

  def touch_in
    raise "Insufficient funds for journey" if @balance < MIN_LIMIT

    @in_use = true
  end

  def touch_out
    deduct(MIN_LIMIT)
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
