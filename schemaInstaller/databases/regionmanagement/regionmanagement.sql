CREATE DATABASE IF NOT EXISTS regionmanagement;

USE regionmanagement;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `REGION_TYPE` (
  `REGION_TYPE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `LEVEL` tinyint(4) NOT NULL,
  `TYPE_NAME` varchar(255) NOT NULL,
  `CREATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `UPDATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `REGION_CATEGORY_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`REGION_TYPE_ID`),
  UNIQUE KEY `level_category_unique` (`REGION_CATEGORY_ID`,`LEVEL`),
  CONSTRAINT `fk_region_category` FOREIGN KEY (`REGION_CATEGORY_ID`) REFERENCES `REGION_CATEGORY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

# Dump of table REGION
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `REGION` (
    `REGION_ID` int(11) NOT NULL AUTO_INCREMENT,
    `REGION_TYPE_ID` int(11) NOT NULL,
    `REGION_NAME` varchar(255) NOT NULL COLLATE utf8_unicode_ci,
    `PATH` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
    `PARENT_REGION_ID` int(11),
    `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `UPDATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `DATA` longtext COLLATE utf8_unicode_ci,
    `location` varchar(64),
    `cluster` varchar(64),
    `distributors` varchar(64),
    `ova_accounts` varchar(45),
    `ID` varchar(250) NOT NULL,
    PRIMARY KEY (`REGION_ID`),
    CONSTRAINT `region_type_id_fk` FOREIGN KEY (`REGION_TYPE_ID`) REFERENCES `REGION_TYPE` (`REGION_TYPE_ID`),
    CONSTRAINT `path_unique` UNIQUE (`PATH`),
    CONSTRAINT `fk_parent_region_id` FOREIGN KEY (`PARENT_REGION_ID`) REFERENCES `REGION`(`REGION_ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# Dump of table REGION_BOUNDARY
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `REGION_BOUNDARY` (
    `REGION_BOUNDARY_ID` int(11) NOT NULL AUTO_INCREMENT,
    `REGION_ID` int(11) NOT NULL,
    `BOUNDARY` POLYGON NOT NULL,
    PRIMARY KEY (`REGION_BOUNDARY_ID`),
    CONSTRAINT `region_id_fk` FOREIGN KEY (`REGION_ID`) REFERENCES `REGION` (`REGION_ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# Dump of table REGION_OWNER_MAP
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `REGION_OWNER_MAP` (
  `REGION_OWNER_MAP_ID` int(11) NOT NULL AUTO_INCREMENT,
  `REGION_ID` int(11) NOT NULL,
  `OWNER_USER_NAME` varchar(255) NOT NULL COLLATE utf8_unicode_ci,
  PRIMARY KEY (`REGION_OWNER_MAP_ID`),
  CONSTRAINT `owner_unique` UNIQUE (`OWNER_USER_NAME`),
  CONSTRAINT `fk_region_id` FOREIGN KEY (`REGION_ID`) REFERENCES `REGION` (`REGION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `cells` (
    `id` varchar(16) NOT NULL,
    `name` varchar(64),
    `region` varchar(250) NOT NULL,
    `district` varchar(70) DEFAULT '',
    `town` varchar(70) DEFAULT '',
    `last_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `accountReseller` (
   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
   `reseller` varchar(64) DEFAULT NULL,
   `account` varchar(64) DEFAULT NULL,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `circle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS`cachedLocationDetail` (
    `msisdnKey` varchar(64) NOT NULL,
    `content` text DEFAULT NULL,
    `last_modified` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY (`msisdnKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `allowedTransfers` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `fromRegion` varchar(250) NOT NULL,
    `toRegion` varchar(250) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `REGION_CATEGORY` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(255) NOT NULL,
  `CREATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `UPDATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `IDENTIFIER` enum('MASTER','SLAVE') NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `LEAF_REGION_MAPPING` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MASTER_ID` int(11) NOT NULL,
  `SLAVE_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_master_leaf_id` (`MASTER_ID`),
  KEY `fk_slave_leaf_id` (`SLAVE_ID`),
  CONSTRAINT `fk_master_leaf_id` FOREIGN KEY (`MASTER_ID`) REFERENCES `REGION` (`REGION_ID`),
  CONSTRAINT `fk_slave_leaf_id` FOREIGN KEY (`SLAVE_ID`) REFERENCES `REGION` (`REGION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

SET FOREIGN_KEY_CHECKS = 0;
COMMIT;