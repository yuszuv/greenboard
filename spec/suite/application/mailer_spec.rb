RSpec.describe HanfBrett::Mailer, :mail do
  include Mail::Matchers

  before :each do
    Mail::TestMailer.deliveries.clear
  end

  let(:from){ Faker::Internet.email }
  let(:to){ Faker::Internet.email }
  let(:mail_subject){ Faker::Cannabis.strain }
  let(:body){ Faker::Lorem.paragraphs(number: 2) }

  let(:args) {
    { from: from,
      to: to,
      subject: mail_subject,
      body: body }
  }

  let(:result){ subject.(**args) }

  it "returns a mail" do
    expect(result).to be_a Mail::Message
  end

  it "sends a mail" do
    expect{ result }.to change{ Mail::TestMailer.deliveries.length }.by(1)
  end

  it "prepends to subject" do
    expect(result.subject).to match /^.+#{mail_subject}$/
  end

end
