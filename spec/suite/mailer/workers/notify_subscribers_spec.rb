RSpec.describe Mailer::Workers::NotifySubscribers do
  let(:id) { 137 }

  let(:mailer) { ->(*args) { double('mail') } }
  let(:view) { ->(subscriber:, card:) { double('body') } }
  let(:card_repo) { instance_double(Mailer::Repositories::Card) }
  let(:subscriber_repo) { instance_double(Mailer::Repositories::Subscriber) }

  let(:subject) do
    described_class.new(
      view: view,
      mailer: mailer,
      card_repo: card_repo,
      subscriber_repo: subscriber_repo
    )
  end
  let(:params) { id }

  let(:result) { subject.(params) }

  context "when the card doesn't exist" do
    before do
      allow(card_repo).to receive(:find) { nil }
    end

    it "fails" do
      expect(mailer).not_to receive(:call)
      expect(subject.(params)).to be_a_failure
    end
  end

  context "when the card exists" do
    before do
      allow(card_repo).to receive(:find) { card }
    end

    context "and a notification for the card was already sent" do
      let(:card) { double("Mailer::Entities::Card", id: id, notification_sent_at: (current_time - 60)) }

      it "sends no email" do
        expect(mailer).not_to receive(:call)
        expect(result).to be_failure
      end
    end

    context "and no notification was sent yet" do
      let(:card) { double('Mailer::Entities::Card', notification_sent_at: nil, id: id) }
      let(:recipients) { 2.times.map{ double('subscriber') } }

      before do
        allow(subscriber_repo).to receive(:active_subscribers) { recipients }
        allow(card_repo).to receive(:update) { card }
      end

      it "sends an email to all subscribers" do
        expect(mailer).to receive(:call).twice
        expect(result).to be_success
        expect(result.value!).to eql({ card: card, recipients: recipients })
      end
    end
  end
end
