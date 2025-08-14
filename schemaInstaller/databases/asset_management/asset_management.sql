START TRANSACTION;

CREATE DATABASE IF NOT EXISTS asset_management;

USE asset_management;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `ersinstall`;
CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `asset_model`;
CREATE TABLE `asset_model` (
   `id` bigint(20) NOT NULL AUTO_INCREMENT,
   `parent_id` bigint(20) DEFAULT NULL,
   `name` varchar(255) NOT NULL,
   `code` varchar(255) DEFAULT 'null',
   `status` varchar(255) NOT NULL,
   `asset_type` enum('POS_TYPE','POS_CATEGORY','POS_VALUE_CLASS','SERVICE_TYPE','BANK','BRANCH','BANNER','BROADCAST','BULLETIN','LEARNING','CONFIGURATION','COMMUNICATION','NOTIFICATION','COMMISSION_BANK','GP_BANK','BTS_MAPPING','BRANCH_ROUTING','DIRECT_RETAIL') NOT NULL,
   `available_from` datetime DEFAULT NULL,
   `available_until` datetime DEFAULT NULL,
   `created_at` datetime(6) NOT NULL,
   `updated_at` datetime(6) DEFAULT NULL,
   `created_by` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`),
   KEY `FKk5wkqw9plyv6mohoi1908sihn` (`parent_id`),
   CONSTRAINT `FKk5wkqw9plyv6mohoi1908sihn` FOREIGN KEY (`parent_id`) REFERENCES `asset_model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `asset_metadata`;
CREATE TABLE `asset_metadata` (
  `asset_id` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `metadata_key` varchar(255) NOT NULL,
  `metadata_value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5strem82ccsmyhogwulkmxjks` (`asset_id`),
  CONSTRAINT `FK5strem82ccsmyhogwulkmxjks` FOREIGN KEY (`asset_id`) REFERENCES `asset_model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;