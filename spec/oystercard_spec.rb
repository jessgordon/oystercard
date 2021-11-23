# frozen_string_literal: true

RSpec.describe Oystercard do
  let(:subject) { Oystercard.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it { is_expected.to be_instance_of Oystercard }

  before :each do |example|
    subject.top_up(50) unless example.metadata[:skip_before]
  end

  it "shows users the balance" do
    expect(subject.balance).to eq 50
  end

  describe "#top_up" do

    it "adds money to my oystercard" do
      expect(subject.top_up(20)).to eq 70
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
      expect(subject.send(:deduct, 5)).to eq 45
    end
  end

  describe "#touch_in" do

    it "records when cardholder is on a journey" do
      expect(subject.touch_in(entry_station)).to eq entry_station
    end

    it "saves the starting station at the point of touch in" do
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end

    it "throws an error if the balance is less than £1", :skip_before do
      expect { subject.touch_in(entry_station) }.to raise_error "Insufficient funds for journey"
    end

  end

  describe "#touch_out" do

    it "records when cardholder ends a journey" do
      expect(subject.touch_out(exit_station)).to eq nil
    end

    it "deduct minimum fare upon touch out" do
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-1)
    end

    it "sets the entry station to nil" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq nil
    end
  end

  describe "#in_journey?" do

    it "returns true if card is in use" do
      subject.touch_in(entry_station)
      expect(subject.in_journey?).to eq true
    end

    it "returns false if card is not in use" do
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq false
    end
  end

  describe "#history" do

    it "records all journeys entries on card" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.history[0]).to include(:entry_station, :exit_station)
    end

    it "initialises a card with empty history list" do
      expect(subject.history).to eq []
    end
  end
end
