# frozen_string_literal: true

RSpec.describe Oystercard do
  let(:subject) { Oystercard.new }

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
end
