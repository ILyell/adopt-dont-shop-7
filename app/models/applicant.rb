class Applicant < ApplicationRecord
    validates :name, presence: true
    validates :street_address, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip_code, presence: true
    validates :description, presence: true
    has_many :applicant_pets
    has_many :pets, through: :applicant_pets

    def pet_app_status(pet_id)
        ApplicantPet.find_by(pet_id: pet_id, applicant_id: self.id)
    end
end