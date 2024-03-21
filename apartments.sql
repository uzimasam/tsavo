-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 21, 2024 at 08:00 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `apartments`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_insert` (IN `BLOCK` VARCHAR(5), IN `APTNUM` VARCHAR(5), OUT `RESULT` INT)   BEGIN
	IF EXISTS(SELECT 1 FROM RESIDENT WHERE PREFERRED_BLOCK = BLOCK AND PREFERRED_APT = APTNUM) THEN
    	SET RESULT = -1;
    ELSE
    	SET RESULT = 1;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `ID_NO` int(11) NOT NULL,
  `EMAIL` varchar(100) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `PASSWORD` varchar(16) NOT NULL,
  `TIMESTAMP` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`ID_NO`, `EMAIL`, `NAME`, `PASSWORD`, `TIMESTAMP`) VALUES
(2, 'uzimasamuel1@gmail.com', 'Sam', 'c718d3f0302f8abb', '0000-00-00 00:00:00'),
(4, 'admin@tsavo.com', 'Admin', '$2y$10$yWSYROAIZ', '0000-00-00 00:00:00'),
(5, 'admin@admin.com', 'Admin', '$2y$10$mLBhOuj3O', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `apartment_details`
--

CREATE TABLE `apartment_details` (
  `BLOCK` varchar(5) NOT NULL,
  `APT_NUM` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `COMPLAINT_ID` int(11) NOT NULL,
  `APT_BLOCK` varchar(5) NOT NULL,
  `APT_NUM` varchar(5) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `SUBJECT` varchar(15) NOT NULL,
  `COMP_BODY` text NOT NULL,
  `DATE_FILED` date NOT NULL,
  `COMP_STATUS` varchar(25) NOT NULL DEFAULT 'NOT RESOLVED'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `complaints`
--
DELIMITER $$
CREATE TRIGGER `comp_on_resolution` AFTER UPDATE ON `complaints` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM complaints WHERE OLD.COMP_STATUS = 'SCHEDULED FOR RESOLUTION' AND NEW.COMP_STATUS = 'RESOLVED') THEN
    	DELETE FROM comp_resolution WHERE COMPLAINT_ID = OLD.COMPLAINT_ID;
    END IF; 
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `comp_resolution`
--

CREATE TABLE `comp_resolution` (
  `COMPLAINT_ID` int(11) NOT NULL,
  `COMP_SUBJECT` text NOT NULL,
  `COMP_HANDLER` varchar(150) NOT NULL,
  `HANDLER_PHONE` bigint(20) NOT NULL,
  `TIMESTAMP` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `comp_resolution`
--
DELIMITER $$
CREATE TRIGGER `comp_on_resolve` AFTER INSERT ON `comp_resolution` FOR EACH ROW BEGIN
    	UPDATE complaints SET COMP_STATUS = "SCHEDULED FOR RESOLUTION", TIMESTAMP = NEW.TIMESTAMP WHERE COMPLAINT_ID = NEW.COMPLAINT_ID;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `formerresident`
--

CREATE TABLE `formerresident` (
  `RES_ID` int(11) NOT NULL,
  `NAME` varchar(150) NOT NULL,
  `PHONE_NO` bigint(20) NOT NULL,
  `EMAILID` varchar(150) NOT NULL DEFAULT 'OPTED OUT',
  `EXITTIMESTAMP` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `GUID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `APT_BLOCK` varchar(10) NOT NULL,
  `APT_NUM` varchar(5) NOT NULL,
  `REASON` text NOT NULL,
  `PHONE` varchar(20) NOT NULL,
  `DATE_OE` varchar(15) NOT NULL,
  `TIME_OE` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `resident`
--

CREATE TABLE `resident` (
  `RES_ID` int(11) NOT NULL,
  `TITLE` varchar(5) NOT NULL,
  `FULLNAME` varchar(100) NOT NULL,
  `LNAME` varchar(100) NOT NULL,
  `DOB` date NOT NULL,
  `PHONE_NO` bigint(20) NOT NULL,
  `EMAIL` varchar(100) NOT NULL,
  `PREV_ADDRESS` varchar(100) NOT NULL,
  `PREFERRED_BLOCK` varchar(3) NOT NULL,
  `PREFERRED_APT` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `resident`
--
DELIMITER $$
CREATE TRIGGER `resident_on_delete` AFTER DELETE ON `resident` FOR EACH ROW BEGIN
	INSERT INTO formerresident(RES_ID,NAME,PHONE_NO) VALUES(OLD.RES_ID,OLD.FULLNAME,OLD.PHONE_NO);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`ID_NO`),
  ADD UNIQUE KEY `EMAIL` (`EMAIL`);

--
-- Indexes for table `apartment_details`
--
ALTER TABLE `apartment_details`
  ADD PRIMARY KEY (`BLOCK`,`APT_NUM`);

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`COMPLAINT_ID`),
  ADD KEY `Apt_Const` (`APT_BLOCK`,`APT_NUM`);

--
-- Indexes for table `comp_resolution`
--
ALTER TABLE `comp_resolution`
  ADD PRIMARY KEY (`COMPLAINT_ID`);

--
-- Indexes for table `formerresident`
--
ALTER TABLE `formerresident`
  ADD PRIMARY KEY (`RES_ID`);

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`GUID`),
  ADD KEY `GID` (`APT_BLOCK`,`APT_NUM`);

--
-- Indexes for table `resident`
--
ALTER TABLE `resident`
  ADD PRIMARY KEY (`RES_ID`),
  ADD KEY `BLAPT` (`PREFERRED_BLOCK`,`PREFERRED_APT`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `ID_NO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `COMPLAINT_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `GUID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resident`
--
ALTER TABLE `resident`
  MODIFY `RES_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comp_resolution`
--
ALTER TABLE `comp_resolution`
  ADD CONSTRAINT `CRID` FOREIGN KEY (`COMPLAINT_ID`) REFERENCES `complaints` (`COMPLAINT_ID`) ON DELETE CASCADE;

--
-- Constraints for table `resident`
--
ALTER TABLE `resident`
  ADD CONSTRAINT `BLAPT` FOREIGN KEY (`PREFERRED_BLOCK`,`PREFERRED_APT`) REFERENCES `apartment_details` (`BLOCK`, `APT_NUM`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
