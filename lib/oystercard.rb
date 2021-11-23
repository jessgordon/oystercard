# frozen_string_literal: true

class Oystercard
  attr_reader :balance, :entry_station, :history

  MAX_LIMIT = 90
  MIN_LIMIT = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @history = []
  end

  def top_up(amount)
    raise "Cannot top-up #{amount}, goes over the limit of £#{MAX_LIMIT}" if limit?(amount)

    @balance += amount
  end

  def limit?(amount)
    (amount + @balance) > MAX_LIMIT
  end

  def touch_in(station_name)
    raise "Insufficient funds for journey" if @balance < MIN_LIMIT

    @entry_station = station_name
  end

  def touch_out(station_name)
    deduct(MIN_LIMIT)
    @history.push({ entry_station: @entry_station, exit_station: station_name })
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
