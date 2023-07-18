class ApplicantPetsController < ApplicationController

    def create
        @applicant_pets = ApplicantPet.create(app_pet_params)
        if @applicant_pets.save
            redirect_to "/applicants/#{app_pet_params[:applicant_id]}"
        end
    end

    private

    def app_pet_params
        params.permit(:applicant_id, :pet_id)
    end
end
