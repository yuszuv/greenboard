RSpec.describe Mailer::Operations::NotifyAdmin do
  let(:id){ 137 }
  let(:card){ double('card', id: id) }

  it "delegates to the worker" do
    expect(Mailer::Workers::NotifyAdmin).to receive(:perform_async).with(id)
    subject.(card)
  end
end
