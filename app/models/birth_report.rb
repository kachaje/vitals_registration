class BirthReport < ActiveRecord::Base
	set_table_name "birth_report"
	set_primary_key "patient_id"
  include Openmrs

end
