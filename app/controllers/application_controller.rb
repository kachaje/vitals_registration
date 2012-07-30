class ApplicationController < GenericApplicationController

  def next_task(patient)
    return "/patients/show/#{patient.id}"     
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id] || session[:patient_id] || params[:id]) rescue nil
  end
  
end
