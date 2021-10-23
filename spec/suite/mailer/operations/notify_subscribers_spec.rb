RSpec.describe Mailer::Operations::NotifySubscribers do
  let(:id){ 137 }
  let(:card){ double('card', id: id) }
  let(:one_hour){ 60 * 60 }

  it "delegates to the worker" do
    expect(Mailer::Workers::NotifySubscribers).to receive(:perform_at).with(current_time + one_hour, id)
    subject.(card, current_time + one_hour)
  end
end
