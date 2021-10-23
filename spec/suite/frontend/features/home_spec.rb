RSpec.feature "Loading the home page", :web do
  scenario "It show a header and the board" do
    visit "/"
    expect(page).to have_content "Grünes Brett"
    expect(page).to have_selector "#board"
  end
end
