class AddStatusToApplicantPets < ActiveRecord::Migration[7.0]
  def change
    add_column :applicant_pets, :status, :string
    change_column_default :applicant_pets, :status, from: nil, to: 'Pending'
  end
end
