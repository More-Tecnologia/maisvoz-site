# Preview all emails at http://localhost:3000/rails/mailers/inspection
class InspectionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/inspection/approved
  def approved
    InspectionMailer.with(inspection: ClubMotorsSubscription.ancore.first).approved
  end

end
