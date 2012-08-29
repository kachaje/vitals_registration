DELIMITER $$
DROP TRIGGER IF EXISTS `relationship_after_delete`$$
CREATE TRIGGER `relationship_after_delete` AFTER UPDATE 
ON `relationship`
FOR EACH ROW
BEGIN
  SET @mother = (SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = "Child" AND b_is_to_a = "Mother");
  SET @father = (SELECT relationship_type_id FROM relationship_type WHERE a_is_to_b = "Child" AND b_is_to_a = "Father");
  
  IF new.relationship = @mother AND new.voided = 1 THEN
  
    UPDATE birth_report SET name_mother = null, home_district_mother = null, home_ta_mother = null, 
        home_village_mother = null, nationality_mother = null, current_district_mother = null, 
        current_village_or_location_mother = null, current_address_mother = null
        WHERE patient_id = new.person_a;
  
  END IF;

  IF new.relationship = @father AND new.voided = 1 THEN
  
    UPDATE birth_report SET name_father = null, home_district_father = null, home_ta_father = null, 
        home_village_father = null, nationality_father = null, current_district_father = null, 
        current_village_or_location_father = null, current_address_father = null
        WHERE patient_id = new.person_a;
        
  END IF;

END$$

DELIMITER ;
