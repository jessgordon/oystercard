# frozen_string_literal: true

class Oystercard
  attr_reader :balance

  LIMIT = 90

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise "Cannot top-up #{amount}, goes over the limit of £#{LIMIT}" if limit?(amount)

    @balance += amount
  end

  def limit?(amount)
    (amount + @balance) > LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end

  def in_journey? 
    @in_use
  end
end
