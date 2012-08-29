DELIMITER $$
DROP TRIGGER IF EXISTS `relationship_after_insert`$$
CREATE TRIGGER `relationship_after_insert` AFTER INSERT 
ON `relationship`
FOR EACH ROW
BEGIN
  SET @mother = (SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = "Child" AND b_is_to_a = "Mother");
  SET @father = (SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = "Child" AND b_is_to_a = "Father");
  SET @serial_number = (SELECT identifier FROM patient_identifier WHERE patient_id = new.person_a AND identifier_type = 
          (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "Serial Number"));
  SET @name = (SELECT CONCAT(given_name, " ", COALESCE(middle_name, ""), " ", family_name) FROM person_name WHERE person_id = new.person_a);
  SET @dob = (SELECT birthdate FROM person WHERE person_id = new.person_a);
  SET @district_of_birth = (SELECT value FROM person_attribute WHERE person_id = new.person_a AND person_attribute_type_id = 
          (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Health District") );
  SET @baby_id_number = (SELECT identifier FROM patient_identifier WHERE patient_id = new.person_a AND identifier_type = 
          (SELECT patient_identifier_type_id FROM patient_identifier_type WHERE name = "National id"));
  
  IF new.relationship = @mother THEN
  
    SET @name_mother = (SELECT CONCAT(given_name, " ", COALESCE(middle_name, ""), " ", family_name, "(", COALESCE(family_name2,""), ")") FROM person_name WHERE person_id = new.person_b);
    SET @home_district_mother = (SELECT subregion FROM person_address WHERE person_id = new.person_b AND COALESCE(subregion,"") != "" LIMIT 1);
    SET @home_ta_mother = (SELECT county_district FROM person_address WHERE person_id = new.person_b AND COALESCE(county_district,"") != "" LIMIT 1);
    SET @home_village_mother = (SELECT neighborhood_cell FROM person_address WHERE person_id = new.person_b AND COALESCE(neighborhood_cell,"") != "" LIMIT 1);
    
    SET @current_district_mother = (SELECT address2 FROM person_address WHERE person_id = new.person_b AND COALESCE(address2,"") != "" LIMIT 1);
    SET @current_village_or_location_mother = (SELECT city_village FROM person_address WHERE person_id = new.person_b AND COALESCE(city_village,"") != "" LIMIT 1);
    SET @current_address_mother = (SELECT address1 FROM person_address WHERE person_id = new.person_b AND COALESCE(address1,"") != "" LIMIT 1);
    
    SET @nationality_mother = (SELECT CASE WHEN value = "Other" THEN 
        COALESCE((SELECT value FROM person_attribute 
          WHERE person_id = new.person_b AND person_attribute_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Race")),"")
        ELSE value END FROM person_attribute WHERE person_id = new.person_b AND person_attribute_type_id = 
          (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Citizenship"));
    
    INSERT INTO birth_report (patient_id, serial_number, name_of_child, date_of_birth, name_mother, home_district_mother, home_ta_mother, 
        home_village_mother, nationality_mother, current_district_mother, current_village_or_location_mother, 
        current_address_mother, baby_id_number, district_of_birth) 
      VALUES (new.person_a, @serial_number, @name, @dob, @name_mother, @home_district_mother, @home_ta_mother, @home_village_mother, 
        @nationality_mother, @current_district_mother, @current_village_or_location_mother, @current_address_mother, 
        @baby_id_number, @district_of_birth) ON DUPLICATE KEY UPDATE patient_id = new.person_a;
  
    UPDATE birth_report SET serial_number = @serial_number, name_of_child = @name, date_of_birth = @dob, 
        name_mother = @name_mother, home_district_mother = @home_district_mother, home_ta_mother = @home_ta_mother, 
        home_village_mother = @home_village_mother, nationality_mother = @nationality_mother, 
        current_district_mother = @current_district_mother, current_village_or_location_mother = @current_village_or_location_mother, 
        current_address_mother = @current_address_mother, baby_id_number = @baby_id_number, district_of_birth = @district_of_birth
        WHERE patient_id = new.person_a;
  
  END IF;

  IF new.relationship = @father THEN
  
    SET @name_father = (SELECT CONCAT(given_name, " ", COALESCE(middle_name, ""), " ", family_name) FROM person_name WHERE person_id = new.person_b);
    SET @home_district_father = (SELECT subregion FROM person_address WHERE person_id = new.person_b AND COALESCE(subregion,"") != "" LIMIT 1);
    SET @home_ta_father = (SELECT county_district FROM person_address WHERE person_id = new.person_b AND COALESCE(county_district,"") != "" LIMIT 1);
    SET @home_village_father = (SELECT neighborhood_cell FROM person_address WHERE person_id = new.person_b AND COALESCE(neighborhood_cell,"") != "" LIMIT 1);
    
    SET @current_district_father = (SELECT address2 FROM person_address WHERE person_id = new.person_b AND COALESCE(address2,"") != "" LIMIT 1);
    SET @current_village_or_location_father = (SELECT city_village FROM person_address WHERE person_id = new.person_b AND COALESCE(city_village,"") != "" LIMIT 1);
    SET @current_address_father = (SELECT address1 FROM person_address WHERE person_id = new.person_b AND COALESCE(address1,"") != "" LIMIT 1);
    
    SET @nationality_father = (SELECT CASE WHEN value = "Other" THEN 
        COALESCE((SELECT value FROM person_attribute 
          WHERE person_id = new.person_b AND person_attribute_type_id = (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Race")),"")
        ELSE value END FROM person_attribute WHERE person_id = new.person_b AND person_attribute_type_id = 
          (SELECT person_attribute_type_id FROM person_attribute_type WHERE name = "Citizenship"));
    
    INSERT INTO birth_report (patient_id, serial_number, name_of_child, date_of_birth, name_father, home_district_father, home_ta_father, 
        home_village_father, nationality_father, current_district_father, current_village_or_location_father, 
        current_address_father, baby_id_number, district_of_birth) 
      VALUES (new.person_a, @serial_number, @name, @dob, @name_father, @home_district_father, @home_ta_father, @home_village_father, 
        @nationality_father, @current_district_father, @current_village_or_location_father, @current_address_father, 
        @baby_id_number, @district_of_birth) ON DUPLICATE KEY UPDATE patient_id = new.person_a;

    
    UPDATE birth_report SET serial_number = @serial_number, name_of_child = @name, date_of_birth = @dob, 
        name_father = @name_father, home_district_father = @home_district_father, home_ta_father = @home_ta_father, 
        home_village_father = @home_village_father, nationality_father = @nationality_father, 
        current_district_father = @current_district_father, current_village_or_location_father = @current_village_or_location_father, 
        current_address_father = @current_address_father, baby_id_number = @baby_id_number, district_of_birth = @district_of_birth
        WHERE patient_id = new.person_a;
        
  END IF;

END$$

DELIMITER ;
