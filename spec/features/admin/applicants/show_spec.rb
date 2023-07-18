require "rails_helper"

RSpec.describe "Admin Applicants Show page" do
  before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV animal shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)
    
    @applicant_1 = Applicant.create(name: "Ian", street_address: "4130 cleveland ave", city: "New Orleans", state: "louisiana", zip_code: 70119, description: "Give dog", status: "Pending")
    @applicant_2 = Applicant.create(name: "Tim", street_address: "130 Bighorn Road", city: "Baton Roughe", state: "louisiana", zip_code: 70121, description: "I wanna have cat", status: "Pending")
    @applicant_3 = Applicant.create(name: "Mike", street_address: "565 Timtown lane", city: "Denver", state: "Colorado", zip_code: 80204, description: "Where cat?", status: "In Progress")
    @pet_1 = @shelter_1.pets.create(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: "Ann", breed: "ragdoll", age: 3, adoptable: false)
    @pet_4 = @shelter_2.pets.create(name: "Ann", breed: "ragdoll", age: 3, adoptable: false)
    @pet_2 = @shelter_3.pets.create(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @applicant_pet_1 = ApplicantPet.create(pet_id: @pet_1.id, applicant_id: @applicant_1.id)
    @applicant_pet_2 = ApplicantPet.create(pet_id: @pet_2.id, applicant_id: @applicant_1.id)
    @applicant_pet_3 = ApplicantPet.create(pet_id: @pet_2.id, applicant_id: @applicant_2.id)
end

  describe "when I visit the admin applicants show page" do
    it 'shows the applicants application' do
      visit "admin/applicants/#{@applicant_1.id}"

      within "#application_info" do
        expect(page).to have_content(@applicant_1.name)
        expect(page).to have_content(@applicant_1.street_address)
        expect(page).to have_content(@applicant_1.status)
      end

      within "#pending_pets" do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_content("Pending")
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_content("Pending")

        expect(page).to have_button("Accept")     
        expect(page).to have_button("Reject")  
      end

      within "#pending_pet_#{@pet_1.id}" do
        expect(page).to have_button("Accept")
        expect(page).to have_button("Reject")
        expect(page).to have_content("Pending")
        click_button "Accept"
      end

      expect(current_path).to eq("/admin/applicants/#{@applicant_1.id}")

      visit "admin/applicants/#{@applicant_1.id}"
      

      within "#pending_pet_#{@pet_1.id}" do
        expect(page).to_not have_button("Accept")
        expect(page).to_not have_button("Reject")
        expect(page).to have_content("Accepted")
      end

      within "#pending_pet_#{@pet_2.id}" do
        expect(page).to have_button("Accept")
        expect(page).to have_button("Reject")
        expect(page).to have_content("Pending")
        click_button "Reject"
      end

      visit "admin/applicants/#{@applicant_1.id}"

      within "#pending_pet_#{@pet_2.id}" do
        expect(page).to_not have_button("Accept")
        expect(page).to_not have_button("Reject")
        expect(page).to have_content("Rejected")
      end
    end
  end
end

# 12. Approving a Pet for Adoption

# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved