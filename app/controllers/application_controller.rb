class ApplicationController < GenericApplicationController
  
  before_filter :authenticate_user!, :except => ['login', 'logout','remote_demographics',
    'create_remote', 'mastercard_printable', 'get_token', 'birth_report_printable', 'import_baby']

  before_filter :set_current_user, :except => ['login', 'logout','remote_demographics',
    'create_remote', 'mastercard_printable', 'get_token', 'birth_report_printable', 'import_baby']

	before_filter :location_required, :except => ['login', 'logout', 'location',
    'demographics','create_remote',
    'mastercard_printable', 'import_baby',
    'remote_demographics', 'get_token', 'single_sign_in', 'birth_report_printable']

  def next_task(patient)
    return "/patients/show/#{patient.id}"     
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id] || session[:patient_id] || params[:id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil
  end
  
end
