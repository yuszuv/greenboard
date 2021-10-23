RSpec.describe Mailer::Repositories::Subscriber, :db do
  describe "#active_subscribers" do
    before do
      Factory[:subscriber]
      Factory[:subscriber, confirmed_at: nil]
      Factory[:subscriber]
    end

    let(:result){ subject.active_subscribers }

    it "finds the active subscribers" do
      expect(result.length).to be 2
    end
  end
end

