class AdminApplicantsController < ApplicationController
    def show
        @applicant = Applicant.find(params[:id])
        @pets = @applicant.pets
    end

    def update
        @applicant = Applicant.find(params[:id])
        applicant_pet = @applicant.pet_app_status(params[:pet_id])
        if params[:commit] == "Accept"
            applicant_pet.update(status: "Accepted")
            redirect_to "/admin/applicants/#{@applicant.id}"
        elsif params[:commit] == "Reject"
            applicant_pet.update(status: "Rejected")
            redirect_to "/admin/applicants/#{@applicant.id}"
        end
    end

    private 

    def admin_app_params
        params.permit(:pet_id)
    end
end