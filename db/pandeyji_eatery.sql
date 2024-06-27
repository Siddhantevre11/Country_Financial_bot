Certainly! Here is your SQL code adapted for an insurance-related project:

```sql
CREATE DATABASE IF NOT EXISTS `insurance_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `insurance_db`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: insurance_db
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `policy_holders`
--

DROP TABLE IF EXISTS `policy_holders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policy_holders` (
  `policy_holder_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`policy_holder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policy_holders`
--

LOCK TABLES `policy_holders` WRITE;
/*!40000 ALTER TABLE `policy_holders` DISABLE KEYS */;
INSERT INTO `policy_holders` VALUES (1, 'John Doe', 35, '123 Main St'), (2, 'Jane Smith', 29, '456 Elm St'), (3, 'Emily Johnson', 42, '789 Oak St');
/*!40000 ALTER TABLE `policy_holders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_policies`
--

DROP TABLE IF EXISTS `insurance_policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_policies` (
  `policy_id` int NOT NULL,
  `policy_holder_id` int NOT NULL,
  `policy_type` varchar(255) DEFAULT NULL,
  `premium` decimal(10,2) DEFAULT NULL,
  `coverage_amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`policy_id`),
  KEY `insurance_policies_ibfk_1` (`policy_holder_id`),
  CONSTRAINT `insurance_policies_ibfk_1` FOREIGN KEY (`policy_holder_id`) REFERENCES `policy_holders` (`policy_holder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_policies`
--

LOCK TABLES `insurance_policies` WRITE;
/*!40000 ALTER TABLE `insurance_policies` DISABLE KEYS */;
INSERT INTO `insurance_policies` VALUES (1, 1, 'Health', 200.00, 10000.00), (2, 1, 'Life', 150.00, 50000.00), (3, 2, 'Auto', 100.00, 20000.00), (4, 3, 'Home', 300.00, 150000.00);
/*!40000 ALTER TABLE `insurance_policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `claims`
--

DROP TABLE IF EXISTS `claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `claims` (
  `claim_id` int NOT NULL,
  `policy_id` int NOT NULL,
  `claim_amount` decimal(10,2) DEFAULT NULL,
  `claim_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `claims_ibfk_1` (`policy_id`),
  CONSTRAINT `claims_ibfk_1` FOREIGN KEY (`policy_id`) REFERENCES `insurance_policies` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `claims`
--

LOCK TABLES `claims` WRITE;
/*!40000 ALTER TABLE `claims` DISABLE KEYS */;
INSERT INTO `claims` VALUES (1, 1, 500.00, 'Approved'), (2, 3, 2000.00, 'Pending'), (3, 4, 15000.00, 'Rejected');
/*!40000 ALTER TABLE `claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'insurance_db'
--
/*!50003 DROP FUNCTION IF EXISTS `get_premium_for_policy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_premium_for_policy`(p_policy_type VARCHAR(255)) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE v_premium DECIMAL(10, 2);
    
    -- Check if the policy_type exists in the insurance_policies table
    IF (SELECT COUNT(*) FROM insurance_policies WHERE policy_type = p_policy_type) > 0 THEN
        -- Retrieve the premium for the policy
        SELECT premium INTO v_premium
        FROM insurance_policies
        WHERE policy_type = p_policy_type;
        
        RETURN v_premium;
    ELSE
        -- Invalid policy_type, return -1
        RETURN -1;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_total_claim_amount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_claim_amount`(p_policy_id INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE v_total_claim_amount DECIMAL(10, 2);
    
    -- Check if the policy_id exists in the claims table
    IF (SELECT COUNT(*) FROM claims WHERE policy_id = p_policy_id) > 0 THEN
        -- Calculate the total claim amount
        SELECT SUM(claim_amount) INTO v_total_claim_amount
        FROM claims
        WHERE policy_id = p_policy_id;
        
        RETURN v_total_claim_amount;
    ELSE
        -- Invalid policy_id, return -1
        RETURN -1;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_claim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @