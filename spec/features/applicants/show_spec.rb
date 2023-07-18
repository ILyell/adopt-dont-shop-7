require 'rails_helper'

RSpec.describe "Applicants Show" do

    before(:each) do
        @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        @applicant_1 = Applicant.create(name: "Ian", street_address: "4130 cleveland ave", city: "New Orleans", state: "louisiana", zip_code: 70119, description: "I wanna have cat")
        @applicant_2 = Applicant.create(name: "Ian", street_address: "850 utica", city: "Denver", state: "Colorado", zip_code: 80204, description: "I need cat")
        @pet_1 = @shelter_1.pets.create(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
        @pet_2 = @shelter_1.pets.create(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
        @pet_3 = @shelter_1.pets.create(name: "Ann", breed: "ragdoll", age: 3, adoptable: false)
        @applicant_pet = ApplicantPet.create(pet_id: @pet_1.id, applicant_id: @applicant_1.id)
    end

    describe "shows the applicant and its attributes including pets" do
        it 'shows the applicant' do
            visit "/applicants/#{@applicant_1.id}"

            expect(page).to have_content(@applicant_1.name)
            expect(page).to have_content(@applicant_1.street_address)
            expect(page).to have_content(@applicant_1.city)
            expect(page).to have_content(@applicant_1.state)
            expect(page).to have_content(@applicant_1.zip_code)
            expect(page).to have_content(@applicant_1.description)
            expect(page).to have_content(@applicant_1.status)
            expect(page).to have_link("#{@pet_1.name}")

            click_link "#{@pet_1.name}"

            expect(current_path).to eq("/pets/#{@pet_1.id}")
        end

        it 'has a search bar for pets that returns the searched pet' do
            visit "/applicants/#{@applicant_1.id}"

            fill_in(:search, with: "Clawdia")

            click_button("Search")

            expect(current_path).to eq("/applicants/#{@applicant_1.id}")

            expect(page).to have_content("Clawdia")

        end

        it 'Has a button to select a pet for the application.' do
            visit "/applicants/#{@applicant_1.id}"

            fill_in(:search, with: "Clawdia")

            click_button("Search")

            expect(current_path).to eq("/applicants/#{@applicant_1.id}")

            expect(page).to have_content("Clawdia")
            expect(page).to have_button("Adopt this Pet")

            click_button("Adopt this Pet")
            
            expect(current_path).to eq("/applicants/#{@applicant_1.id}")
            
        end
    end

    describe 'After an applicant has added one or more pets to the application' do
        it 'allows you to sumbit the application' do
            visit "/applicants/#{@applicant_1.id}"

            expect(page).to have_content("Add a Pet to this Application!")

            within "#pet_search" do
                fill_in(:search, with: "Clawdia")
                click_button("Search")
            end
            

            within "#pet_submit" do
                click_button("Adopt this Pet")
            end

            within "#application_submit" do
                click_button("Submit Application")
            end

            expect(page).to have_content("Clawdia")
            expect(page).to have_content("Pending")
            expect(page).to_not have_button("Submit")
        end               
    end

    describe "If a application dosent have pets" do
        it "Dosent allow you to submit" do
            visit "/applicants/#{@applicant_2.id}"

            within "#application_submit" do
                expect(page).to_not have_button("Submit")
            end
        end
    end
end