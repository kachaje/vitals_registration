INSERT INTO `relationship_type` (`a_is_to_b`, `b_is_to_a`, `preferred`, `weight`, `description`, `creator`, `date_created`, `uuid`) VALUES ('Child', 'Mother', 0, 0, 'Mother-child relationship', 1, '2012-08-08 13:41:00', (SELECT UUID()));
INSERT INTO `relationship_type` (`a_is_to_b`, `b_is_to_a`, `preferred`, `weight`, `description`, `creator`, `date_created`, `uuid`) VALUES ('Child', 'Father', 0, 0, 'Father-child relationship', 1, '2012-08-08 13:41:00', (SELECT UUID()));

