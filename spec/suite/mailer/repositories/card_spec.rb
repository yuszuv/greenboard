RSpec.describe Mailer::Repositories::Card, :db do
  let(:id){ 137 }

  describe "#find" do
    let(:result){ subject.find(id) }

    context "when the card exists" do
      before do
        Factory[:card, id: id]
      end

      it "finds the card" do
        expect(result).to_not be_nil
      end
    end

    context "when the card does not exist" do
      it "doesn't find anything" do
        expect(result).to be_nil
      end
    end
  end
end

