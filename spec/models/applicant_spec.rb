require 'rails_helper'

RSpec.describe Applicant, type: :model do

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
        @applicant_pet_3 = ApplicantPet.create(pet_id: @pet_2.id, applicant_id: @applicant_2.id, status: "Approved")
    end
    
    describe 'relationships' do
        it { should have_many(:applicant_pets) }
        it { should have_many(:pets).through(:applicant_pets)}
    end

    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:street_address) }
        it { should validate_presence_of(:city) }
        it { should validate_presence_of(:state) }
        it { should validate_presence_of(:zip_code) }
        it { should validate_presence_of(:description) }
    end

    describe "#class methods" do
        describe "#pet_app_status(pet_id)" do
            it 'returns the application status of a given pet for the applicant' do
                expect(@applicant_1.pet_app_status(@pet_1.id).status).to eq("Pending")
                expect(@applicant_1.pet_app_status(@pet_2.id).status).to eq("Pending")
                expect(@applicant_2.pet_app_status(@pet_2.id).status).to eq("Approved")
            end
        end
    end
end