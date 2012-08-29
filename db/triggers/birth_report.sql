-- MySQL dump 10.13  Distrib 5.5.24, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: vitals_registration_development
-- ------------------------------------------------------
-- Server version	5.5.24-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `birth_report`
--

DROP TABLE IF EXISTS `birth_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `birth_report` (
  `patient_id` int(11) NOT NULL,
  `serial_number` varchar(45) DEFAULT NULL,
  `name_of_child` varchar(255) DEFAULT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `name_father` varchar(255) DEFAULT NULL,
  `home_district_father` varchar(255) DEFAULT NULL,
  `home_ta_father` varchar(255) DEFAULT NULL,
  `home_village_father` varchar(255) DEFAULT NULL,
  `name_mother` varchar(255) DEFAULT NULL,
  `home_district_mother` varchar(255) DEFAULT NULL,
  `home_ta_mother` varchar(255) DEFAULT NULL,
  `home_village_mother` varchar(255) DEFAULT NULL,
  `nationality_mother` varchar(255) DEFAULT NULL,
  `nationality_father` varchar(255) DEFAULT NULL,
  `current_district_mother` varchar(255) DEFAULT NULL,
  `current_village_or_location_mother` varchar(255) DEFAULT NULL,
  `current_address_mother` varchar(255) DEFAULT NULL,
  `current_district_father` varchar(255) DEFAULT NULL,
  `current_village_or_location_father` varchar(255) DEFAULT NULL,
  `baby_id_number` varchar(255) DEFAULT NULL,
  `district_of_birth` varchar(255) DEFAULT NULL,
  `district_commissioner` varchar(255) DEFAULT NULL,
  `current_address_father` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `birth_report_id_UNIQUE` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-29 12:27:07
