class PatientsController < ApplicationController
  before_filter :find_patient, :except => [:void]
  
  def show 
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil

    @father = @anc_patient.father rescue nil

    @mother = @anc_patient.mother rescue nil

    redirect_to "/patients/serial_number/#{@patient.id}" and return if @anc_patient.serial_number.nil?

    render :layout => 'dynamic-dashboard'
  end

  def custom_banner
    render :layout => false
  end

  def demographics
    @person = Patient.find(params[:person_id]) rescue nil
    @update_patient = ANCService::ANC.new(@person) rescue nil

    @national_id = @update_patient.national_id_with_dashes rescue nil

    @first_name = @person.person.names.first.given_name rescue nil
    @last_name = @person.person.names.first.family_name rescue nil
    @maiden_name = @person.person.names.first.family_name2 rescue nil
    @birthdate = @update_patient.birthdate_formatted rescue nil
    @gender = @update_patient.sex rescue ''

    @current_village = @person.person.addresses.first.city_village rescue ''
    @current_ta = @person.person.addresses.first.county_district rescue ''
    @current_district = @person.person.addresses.first.state_province rescue ''
    @home_district = @person.person.addresses.first.address2 rescue ''

    @primary_phone = @update_patient.phone_numbers[:cell_phone_number] rescue ''
    @secondary_phone = @update_patient.phone_numbers["Home Phone Number"] rescue ''

    @occupation = @update_patient.get_attribute("occupation") rescue ''

    @baby = (!params[:cat].nil? ? (params[:cat].downcase == "baby" ? true : false) : false)

    render :template => 'patients/demographics', :layout => 'menu'

  end

  def edit_demographics
    @person = Patient.find(params[:person_id]) rescue nil
    @field = params[:field]
    render :partial => "edit_demographics", :field =>@field, :layout => true and return
  end

  def update_demographics
    ANCService.update_demographics(params)
    redirect_to :action => 'demographics', :patient_id => params['patient_id'], 
      :person_id => params['person_id'], :cat => params['cat'] and return
  end

  def search
    render :layout => "dynamic-dashboard"
  end

  def summary
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    @father = @anc_patient.father rescue nil
    
    @mother = @anc_patient.mother rescue nil
    
    render :layout => false
  end

  def siblings
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    @father = @anc_patient.father rescue nil

    @mother = @anc_patient.mother rescue nil

    @siblings = @anc_patient.siblings.collect{|s| ANCService::ANC.new(s.person.patient)} rescue []

    render :layout => false
  end

  def birth_report
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil
  end

  def birth_report_printable
    @patient = Patient.find(params[:id] || params[:patient_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    @father = @anc_patient.father rescue nil

    @mother = @anc_patient.mother rescue nil

    @anc_mother = ANCService::ANC.new(@mother.relation.patient) rescue nil

    @anc_father = ANCService::ANC.new(@father.relation.patient) rescue nil

    render :layout => false
  end

  def print_note
    # raise request.remote_ip.to_yaml

    location = request.remote_ip rescue ""
    @patient    = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
    
    if @patient
      current_printer = ""

      wards = GlobalProperty.find_by_property("facility.ward.printers").property_value.split(",") rescue []

      printers = wards.each{|ward|
        current_printer = ward.split(":")[1] if ward.split(":")[0].upcase == location
      } rescue []

      t1 = Thread.new{
        
        Kernel.system "wkhtmltopdf -s A4 http://" +
          request.env["HTTP_HOST"] + "\"/patients/birth_report_printable/" +
          @patient.id.to_s + "\" /tmp/output-" + session[:user_id].to_s + ".pdf \n"
      }

      t2 = Thread.new{
        sleep(5)
        Kernel.system "lp #{(!current_printer.blank? ? '-d ' + current_printer.to_s : "")} /tmp/output-" +
          session[:user_id].to_s + ".pdf\n"
      }

      t3 = Thread.new{
        sleep(10)
        Kernel.system "rm /tmp/output-" + session[:user_id].to_s + ".pdf\n"
      }

    end

    redirect_to "/patients/show/#{@patient.id}" and return
  end

  def provider_details
    @patient = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
    
  end

  def provider_tab
    @patient = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    render :layout => false
  end

  def create_provider
    @patient = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
    @anc_patient = ANCService::ANC.new(@patient) rescue nil

    if !params[:HospitalDate].nil? && !params[:HospitalDate].blank?
      @anc_patient.set_attribute("Hospital Date", params[:HospitalDate])
    end

    if !params[:Hospital].nil? && !params[:Hospital].blank?
      @anc_patient.set_attribute("Health Center", params[:Hospital])
    end

    if !params[:district].nil? && !params[:district].blank?
      @anc_patient.set_attribute("Health District", params[:district])
    end

    if !params[:ProviderTitle].nil? && !params[:ProviderTitle].blank?
      @anc_patient.set_attribute("Provider Title", params[:ProviderTitle])
    end

    if !params[:ProviderName].nil? && !params[:ProviderName].blank?
      @anc_patient.set_attribute("Provider Name", params[:ProviderName])
    end

    redirect_to "/patients/show/#{@patient.id}"
  end

  def static_locations
    search_string = (params[:search_string] || "").upcase

    locations = []

    File.open(RAILS_ROOT + "/public/data/locations.txt", "r").each{ |loc|
      locations << loc if loc.upcase.strip.match(search_string)
    }

    render :text => "<li></li><li " + locations.map{|location| "value=\"#{location}\">#{location}" }.join("</li><li ") + "</li>"

  end

  def void_provider
    @attribute = PersonAttribute.find(params[:id])
    @attribute.void
    head :ok
  end

  def serial_number
    @patient = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil
  end

  def create_serial_number
    @patient = Patient.find(params[:patient_id] || params[:id] || session[:patient_id]) rescue nil

    @anc_patient.set_identifier("Serial Number", params["serial_number"]) if !params["serial_number"].blank?

    redirect_to "/patients/show/#{@patient.id}" and return
  end

  private

end
