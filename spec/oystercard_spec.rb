# frozen_string_literal: true

RSpec.describe Oystercard do
  it { is_expected.to be_instance_of Oystercard }

  it "shows users the balance" do
    expect(subject.balance).to eq 0
  end
end
