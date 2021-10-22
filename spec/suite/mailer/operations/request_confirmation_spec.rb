RSpec.describe Mailer::Operations::RequestConfirmation, :focus do
  let!(:subscriber){ double('subscriber', email: Faker::Internet.email) }
  let!(:mail){ double('mail') }

  let(:mailer){ ->(*args){ mail } }
  let(:view){ ->(subscriber:){ nil } }

  let(:subject) do
    described_class.new(
      mailer: mailer,
      view: view
    )
  end
  let(:arg){ subscriber }

  let(:result){ subject.(arg) }

  it "sends a confirmation mail to the subscriber" do
    expect(mailer).to receive(:call){ mail }
    expect(view).to receive(:call).with(hash_including(subscriber: subscriber))
    expect(result).to be_a_success
    expect(result.value!).to eq(mail: mail, subscriber: subscriber)
  end

  context "the mail server is refusing connection" do
    before :each do
      allow(mailer).to receive(:call).and_raise(Errno::ECONNREFUSED)
    end

    it "returns a failure" do
      expect(result).to be_a_failure
    end
  end
end
