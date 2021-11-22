# frozen_string_literal: true

RSpec.describe Oystercard do
  it { is_expected.to be_instance_of Oystercard }

  it "shows users the balance" do
    expect(subject.balance).to eq 0
  end

  describe "#top_up" do
    it "adds money to my oystercard" do
      oystercard = Oystercard.new
      expect(oystercard.top_up(20)).to eq 20
    end
  end
end
