RSpec.feature "Loading the home page", :web do
  scenario "It shows the page title" do
    visit "/"
    expect(page).to have_content "Grünes Brett"
  end
end
