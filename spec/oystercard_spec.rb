# frozen_string_literal: true

RSpec.describe Oystercard do
  let(:subject) { Oystercard.new }
  let(:station) { double :station }

  it { is_expected.to be_instance_of Oystercard }

  it "shows users the balance" do
    expect(subject.balance).to eq 0
  end

  describe "#top_up" do
    it "adds money to my oystercard" do
      expect(subject.top_up(20)).to eq 20
    end

    it "throws an exception if the new balance exceeds the limit" do
      expect { subject.top_up(100) }.to raise_error "Cannot top-up 100, goes over the limit of £90"
    end
  end

  describe "#limit?" do
    it "verifies the balance is under the limit" do
      expect(subject.limit?(10)).to eq false
    end

    it "verifies the balance is over the limit" do
      expect(subject.limit?(100)).to eq true
    end
  end

  describe "#deduct" do
    it "deducts fair from card" do
      subject.top_up(50)
      expect(subject.send(:deduct, 5)).to eq 45
    end
  end

  describe "#touch_in" do
    it "records when cardholder is on a journey" do
      subject.top_up(50)
      expect(subject.touch_in(station)).to eq station
    end

    it "throws an error if the balance is less than £1" do
      expect { subject.touch_in(station) }.to raise_error "Insufficient funds for journey"
    end

    it "saves the starting station at the point of touch in" do
      subject.top_up(50)
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end
  end

  describe "#touch_out" do
    it "records when cardholder ends a journey" do
      expect(subject.touch_out).to eq nil
    end

    it "deduct minimum fare upon touch out" do
      subject.top_up(50)
      subject.touch_in(station)
      expect { subject.touch_out }.to change { subject.balance }.by(-1)
    end

    it "sets the entry station to nil" do
      subject.top_up(50)
      subject.touch_in(station)
      subject.touch_out
      expect(subject.entry_station).to eq nil
    end
  end

  describe "#in_journey?" do
    it "returns true if card is in use" do
      subject.top_up(50)
      subject.touch_in(station)
      expect(subject.in_journey?).to eq true
    end

    it "returns false if card is not in use" do
      subject.touch_out
      expect(subject.in_journey?).to eq false
    end
  end
end
