RSpec.describe Mailer::Workers::NotifyAdmin do
  let(:id) { 137 }
  let(:email) { Faker::Internet.email }

  let(:mailer) { ->(*args) { double('mail', to: email) } }
  let(:view) { ->(card:) { double('body') } }
  let(:repo) { instance_double(Mailer::Repositories::Card) }
  let(:logger) { double('logger', info: nil) }

  let(:subject) do
    described_class.new(
      view: view,
      mailer: mailer,
      repo: repo,
      logger: logger
    )
  end

  let(:params) { id }
  let(:result) { subject.(params) }

  context "when the card doesn't exist" do
    before do
      allow(repo).to receive(:find) { nil }
    end

    it "fails" do
      expect(mailer).not_to receive(:call)
      expect(subject.(params)).to be_a_failure
    end
  end

  context "when the card exists" do
    before do
      allow(repo).to receive(:find) { card }
    end

    let(:card) { double('Mailer::Entities::Card', id: id) }

    it "sends an email to the admin" do
      expect(mailer).to receive(:call).and_call_original
      expect(result).to be_success
      expect(result.value!).to eql(card: card, recipient: email)
    end
  end
end
