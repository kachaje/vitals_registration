class PeopleController < GenericPeopleController
   
  def create
    # raise params.to_yaml
   
    hiv_session = false
    if current_program_location == "HIV program"
      hiv_session = true
    end
    
    person = PatientService.create_patient_from_dde(params) if create_from_dde_server

    unless person.blank?

      encounter = Encounter.new(params[:encounter])
      encounter.patient_id = person.id
      encounter.encounter_datetime = session[:datetime] unless session[:datetime].blank?
      encounter.save

      if !params[:cat].nil? && !params[:patient_id].nil?
        redirect_to "/relationships/new?patient_id=#{params[:patient_id]}&relation=#{person.id
            }&cat=#{params[:cat]}" and return
      else

        # print_and_redirect("/patients/national_id_label?patient_id=#{person.id}", next_task(person.patient))

        redirect_to next_task(person.patient) and return

      end
    end

    success = false
    Person.session_datetime = session[:datetime].to_date rescue Date.today
    
    #for now BART2 will use BART1 for patient/person creation until we upgrade BART1 to 2
    #if GlobalProperty.find_by_property('create.from.remote') and property_value == 'yes'
    #then we create person from remote machine
    if create_from_remote
      person_from_remote = PatientService.create_remote_person(params)
      person = PatientService.create_from_form(person_from_remote["person"]) unless person_from_remote.blank?

      if !person.blank?
        success = true
        person.patient.remote_national_id
      end
    else
      success = true
      person = PatientService.create_from_form(params[:person])
    end

    encounter = Encounter.new(params[:encounter])
    encounter.patient_id = person.id
    encounter.encounter_datetime = session[:datetime] unless session[:datetime].blank?
    encounter.save   

    if params[:person][:patient] && success
      PatientService.patient_national_id_label(person.patient)
      # unless (params[:relation].blank?)
      #  redirect_to search_complete_url(person.id, params[:relation]) and return
      if !params[:cat].nil? && !params[:patient_id].nil?        
        redirect_to "/relationships/new?patient_id=#{params[:patient_id]}&relation=#{person.id
            }&cat=#{params[:cat]}" and return
      else

        # print_and_redirect("/patients/national_id_label?patient_id=#{person.id}", next_task(person.patient))

        redirect_to next_task(person.patient) and return
        
      end
    else
      # Does this ever get hit?
      redirect_to :action => "index"
    end
  end

	def search
      
		found_person = nil
		if params[:identifier]
			local_results = PatientService.search_by_identifier(params[:identifier])

			if local_results.length > 1
				@people = PatientService.person_search(params)
			elsif local_results.length == 1
				found_person = local_results.first
        
			else
				# TODO - figure out how to write a test for this
				# This is sloppy - creating something as the result of a GET
				if create_from_remote        
					found_person_data = PatientService.find_remote_person_by_identifier(params[:identifier])
					found_person = PatientService.create_from_form(found_person_data['person']) unless found_person_data.nil?
				end
			end     

			if found_person
=begin
        patient = DDEService::Patient.new(found_person.patient)

        patient.check_old_national_id(params[:identifier])
=end

				if params[:cat] && params[:cat] != "baby" && params[:patient_id]
          redirect_to "/relationships/new?patient_id=#{params[:patient_id]}&relation=#{found_person.id
            }&cat=#{params[:cat]}" and return
				else
          
          redirect_to next_task(found_person.patient) and return
          
					# redirect_to :action => 'confirm', :found_person_id => found_person.id, :relation => params[:relation] and return
				end
			end
		end
		@relation = params[:relation]
		@people = ANCService.person_search(params)
		@patients = []

		@people.each do | person |
			patient = PatientService.get_patient(person) rescue nil
			@patients << patient
		end

	end

	# This method is just to allow the select box to submit, we could probably do this better
	def select
    
    if params[:person][:id] != '0' && Person.find(params[:person][:id]).dead == 1

			redirect_to :controller => :patients, :action => :show, :id => params[:person]
		else
      
			redirect_to search_complete_url(params[:person][:id], params[:relation], params[:cat]) and return if (!params[:person][:id].blank? || !params[:person][:id] == '0') && params[:cat] == "baby"
      
      redirect_to "/relationships/new?patient_id=#{params[:patient_id]}&relation=#{params[:person][:id]
            }&cat=#{params[:cat]}" and return if (!params[:person][:id].blank? || !params[:person][:id] == '0') and
        (params[:cat] and params[:cat] != "baby")

      if params[:cat] and params[:cat] == "baby"
        redirect_to :action => :new_baby,
          :gender => params[:gender],
          :given_name => params[:given_name],
          :family_name => params[:family_name],
          :family_name2 => params[:family_name2],
          :address2 => params[:address2], 
          :identifier => params[:identifier],
          :relation => params[:relation]
      else
        redirect_to :action => :new, :gender => params[:gender], 
          :given_name => params[:given_name],
          :family_name => params[:family_name],
          :family_name2 => params[:family_name2],
          :address2 => params[:address2],
          :identifier => params[:identifier],
          :relation => params[:relation],
          :patient_id => params[:patient_id],
          :cat => params[:cat]
      end
		end
	end

  def confirm
    redirect_to "/patients/show/#{params[:found_person_id]}" and return
  end

  def import_baby
    User.current = User.first
    
    remote_params = params
    remote_params = remote_params.reject{|key,value| key.match(/controller|action/) }
    
    result = ANCService.import_person_no_questions(remote_params) # rescue "Baby Addition Failed"

    render :text => result
  end

  private

	def search_complete_url(found_person_id, primary_person_id, category)
    # raise category.to_yaml
    
		unless (primary_person_id.blank?)
			# Notice this swaps them!
			new_relationship_url(:patient_id => primary_person_id, :relation => found_person_id)
		else
			#
			# Hack reversed to continue testing overnight
			#
			# TODO: This needs to be redesigned!!!!!!!!!!!
			#
			#url_for(:controller => :encounters, :action => :new, :patient_id => found_person_id)
			patient = Person.find(found_person_id).patient
			show_confirmation = CoreService.get_global_property_value('show.patient.confirmation').to_s == "true" rescue false
			if show_confirmation
				url_for(:controller => :people, :action => :confirm , :found_person_id =>found_person_id, :cat => category)
			else
				next_task(patient)
			end
		end
	end
end
 
