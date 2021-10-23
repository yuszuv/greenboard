RSpec.describe Api::Actions::SubscribeUpdates, :mail do
  let(:email) { Faker::Internet.email }
  let(:tos){ true }

  let(:params) do
    {
      email: email,
      tos: tos
    }
  end

  let(:result){ subject.(params) }
  let(:status){ result.status }
  let(:body){ result.body }

  it "subscribes the user succesfully to updates" do
    expect(status).to be 200
  end

  context "when the email is already subscribed" do
    before :each do
      Factory[:subscriber, email: email]
    end

    it "fails" do
      expect(status).to be 400
    end
  end

  context "when the user does not accept the TOS" do
    let(:tos){ false }

    it "fails" do
      expect(status).to be 400
    end
  end
end

