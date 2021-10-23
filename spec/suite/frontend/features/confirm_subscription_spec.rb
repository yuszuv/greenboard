RSpec.feature "Loading the home page", :web, :db do
  before :each do
    Factory[:subscriber, confirmation_token: token]
  end

  let(:token){ SecureRandom.hex(24) }

  context "with a valid token" do
    scenario "succeeds" do
      visit "/abonnement_bestaetigen?token=#{token}"
      expect(page).to have_content "Automatische Benachrichtigung bestätigt"
    end
  end

  context "with an invalid token" do
    scenario "it return a 404" do
      visit "/abonnement_bestaetigen?token=somerandomstuff"
      expect(page.status_code).to be 404
    end
  end
end
