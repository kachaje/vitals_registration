INSERT INTO `vitals_registration_development`.`person_attribute_type` (`name`, `description`, `creator`, `date_created`, `changed_by`, `date_changed`, `uuid`, `sort_weight`) VALUES ('Provider Title', 'Birth Registration field', 1, '2012-08-09 00:00:00', NULL, NULL, (SELECT UUID()), 0);
INSERT INTO `vitals_registration_development`.`person_attribute_type` (`name`, `description`, `creator`, `date_created`, `uuid`, `sort_weight`) VALUES ('Hospital Date', 'Birth Registration field', 1, '2012-08-09 00:00:00', (SELECT UUID()), 0);
INSERT INTO `vitals_registration_development`.`person_attribute_type` (`name`, `description`, `creator`, `date_created`, `uuid`, `sort_weight`) VALUES ('Provider Name', 'Birth Registration field', 1, '2012-08-09 00:00:00', (SELECT UUID()), 0);

