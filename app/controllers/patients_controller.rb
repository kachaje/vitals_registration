class PatientsController < ApplicationController
  before_filter :find_patient, :except => [:void]
  
  def show 
    
    render :layout => 'dynamic-dashboard'
  end

  def custom_banner
    render :layout => false
  end
  
  private

end
