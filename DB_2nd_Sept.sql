-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: local_conveyance
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Current Database: `local_conveyance`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `local_conveyance` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `local_conveyance`;

--
-- Table structure for table `taxi`
--

DROP TABLE IF EXISTS `taxi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxi` (
  `tx_id` int NOT NULL AUTO_INCREMENT,
  `taxi_number` varchar(255) NOT NULL,
  `operational_city` varchar(255) NOT NULL,
  `rate_km` int NOT NULL,
  PRIMARY KEY (`tx_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxi`
--

LOCK TABLES `taxi` WRITE;
/*!40000 ALTER TABLE `taxi` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxi_bookings`
--

DROP TABLE IF EXISTS `taxi_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxi_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `tx_id` int NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `fk_taxi_idx` (`tx_id`),
  CONSTRAINT `fk_taxi` FOREIGN KEY (`tx_id`) REFERENCES `taxi` (`tx_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxi_bookings`
--

LOCK TABLES `taxi_bookings` WRITE;
/*!40000 ALTER TABLE `taxi_bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxi_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'local_conveyance'
--

--
-- Current Database: `user`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `user` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `user`;

--
-- Table structure for table `tenant`
--

DROP TABLE IF EXISTS `tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant` (
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant`
--

LOCK TABLES `tenant` WRITE;
/*!40000 ALTER TABLE `tenant` DISABLE KEYS */;
INSERT INTO `tenant` VALUES ('tenant1','tenant1@gmail.com','abc');
/*!40000 ALTER TABLE `tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenant_service`
--

DROP TABLE IF EXISTS `tenant_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_service` (
  `username` varchar(255) NOT NULL,
  `service_type` varchar(255) NOT NULL,
  PRIMARY KEY (`username`,`service_type`),
  KEY `fk_tenant_idx` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_service`
--

LOCK TABLES `tenant_service` WRITE;
/*!40000 ALTER TABLE `tenant_service` DISABLE KEYS */;
INSERT INTO `tenant_service` VALUES ('tenant1@gmail.com','flight'),('tenant1@gmail.com','hotel'),('tenant1@gmail.com','taxi'),('tenant1@gmail.com','train');
/*!40000 ALTER TABLE `tenant_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `username` varchar(255) NOT NULL,
  `tenant_username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`),
  KEY `fk_tenant_idx` (`tenant_username`),
  CONSTRAINT `fk_user_tenant` FOREIGN KEY (`tenant_username`) REFERENCES `tenant` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'user'
--

--
-- Current Database: `travel`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `travel` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `travel`;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `fl_id` int NOT NULL AUTO_INCREMENT,
  `airline_service` varchar(255) NOT NULL,
  `from_city` varchar(255) NOT NULL,
  `to_city` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `available_seats` int NOT NULL,
  PRIMARY KEY (`fl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flight_bookings`
--

DROP TABLE IF EXISTS `flight_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `fl_id` int NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `fk_flight_idx` (`fl_id`),
  CONSTRAINT `fk_flight` FOREIGN KEY (`fl_id`) REFERENCES `flight` (`fl_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight_bookings`
--

LOCK TABLES `flight_bookings` WRITE;
/*!40000 ALTER TABLE `flight_bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `flight_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `tr_id` int NOT NULL AUTO_INCREMENT,
  `train_name` varchar(255) NOT NULL,
  `from_city` varchar(255) NOT NULL,
  `to_city` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `available_seats` int NOT NULL,
  PRIMARY KEY (`tr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_bookings`
--

DROP TABLE IF EXISTS `train_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `tr_id` int NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `fk_train_idx` (`tr_id`),
  CONSTRAINT `fk_train` FOREIGN KEY (`tr_id`) REFERENCES `train` (`tr_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_bookings`
--

LOCK TABLES `train_bookings` WRITE;
/*!40000 ALTER TABLE `train_bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `train_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'travel'
--

--
-- Current Database: `stay`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `stay` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `stay`;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel` (
  `ht_id` int NOT NULL AUTO_INCREMENT,
  `hotel_name` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `price` int NOT NULL,
  `available_rooms` int NOT NULL,
  PRIMARY KEY (`ht_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_bookings`
--

DROP TABLE IF EXISTS `hotel_bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `ht_id` int NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `fk_hotel_idx` (`ht_id`),
  CONSTRAINT `fk_hotel` FOREIGN KEY (`ht_id`) REFERENCES `hotel` (`ht_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_bookings`
--

LOCK TABLES `hotel_bookings` WRITE;
/*!40000 ALTER TABLE `hotel_bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'stay'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-02 17:28:08
