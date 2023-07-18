class AddDefaultStatusToApplicants < ActiveRecord::Migration[7.0]
  def change
    change_column_default :applicants, :status, from: nil, to: 'In progress'
  end
end
