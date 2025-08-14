START TRANSACTION;

CREATE DATABASE IF NOT EXISTS groupmanagementsystem;

USE groupmanagementsystem;

SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------
--  Table structure for `ersinstall`
-- ------------------------------------
DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `admin_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `id_type` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL,
  `extra_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_params`)),
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table ersinstall
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ersinstall`;

CREATE TABLE `ersinstall` (
  `versionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `version` varchar(20) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`versionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group`;

CREATE TABLE `group` (
  `group_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(15) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(60) DEFAULT NULL,
  `minimum_members` int(11) DEFAULT NULL,
  `maximum_members` int(11) DEFAULT NULL,
  `effective_from` datetime NOT NULL,
  `valid_until` datetime DEFAULT NULL,
  `created_by` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `last_modified` datetime NOT NULL,
  `group_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`group_data`)),
  `status_update_date` datetime NOT NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table group_admin
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_admin`;

CREATE TABLE `group_admin` (
  `group_id` bigint(20) NOT NULL,
  `admin_id` bigint(20) NOT NULL,
  `effective_from` datetime NOT NULL,
  `effective_until` datetime NOT NULL,
  `status` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`group_id`,`admin_id`),
  KEY `admin_id_fk` (`admin_id`),
  CONSTRAINT `admin_id_fk` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON UPDATE CASCADE,
  CONSTRAINT `group_id_fk_02` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table group_member
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_member`;

CREATE TABLE `group_member` (
  `group_id` bigint(20) NOT NULL,
  `member_id` bigint(20) NOT NULL,
  `effective_from` datetime NOT NULL,
  `effective_until` datetime NOT NULL,
  `member_type` varchar(60) DEFAULT NULL,
  `status` varchar(60) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`group_id`,`member_id`),
  KEY `member_id_fk` (`member_id`),
  CONSTRAINT `group_id_fk_01` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`) ON UPDATE CASCADE,
  CONSTRAINT `member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table group_relation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_relation`;

CREATE TABLE `group_relation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_group_id` bigint(20) NOT NULL,
  `operation_id` bigint(20) NOT NULL,
  `to_group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_group_relation` (`from_group_id`,`operation_id`,`to_group_id`),
  KEY `operation_id_fk` (`operation_id`),
  KEY `to_group_id_fk` (`to_group_id`),
  CONSTRAINT `from_group_id_fk` FOREIGN KEY (`from_group_id`) REFERENCES `group` (`group_id`) ON UPDATE CASCADE,
  CONSTRAINT `operation_id_fk` FOREIGN KEY (`operation_id`) REFERENCES `operation` (`operation_id`) ON UPDATE CASCADE,
  CONSTRAINT `to_group_id_fk` FOREIGN KEY (`to_group_id`) REFERENCES `group` (`group_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table member
# ------------------------------------------------------------

DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
  `member_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `id_type` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL,
  `extra_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_params`)),
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table operation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `operation`;

CREATE TABLE `operation` (
  `operation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(60) NOT NULL,
  `module` varchar(60) NOT NULL,
  `operation_name` varchar(60) NOT NULL,
  `operation_type` varchar(60) NOT NULL,
  `from_state` varchar(60) NOT NULL,
  `to_state` varchar(60) NOT NULL,
  PRIMARY KEY (`operation_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table workflow
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workflow`;

CREATE TABLE `workflow` (
  `id` varchar(200) NOT NULL DEFAULT '',
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `created_by` varchar(200) NOT NULL,
  `created_date` datetime NOT NULL,
  `last_modified_date` datetime DEFAULT NULL,
  `valid_until` datetime DEFAULT '2099-06-24 10:37:25',
  `is_deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table workflow_group_order
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workflow_group_order`;

CREATE TABLE `workflow_group_order` (
  `id` varchar(200) NOT NULL,
  `workflow_id` varchar(200) DEFAULT NULL,
  `workflow_order` int(11) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_wgo1` (`workflow_id`),
  KEY `fk_wgo2` (`group_id`),
  CONSTRAINT `fk_wgo1` FOREIGN KEY (`workflow_id`) REFERENCES `workflow` (`id`),
  CONSTRAINT `fk_wgo2` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



# Dump of table workflow_tracker
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workflow_tracker`;

CREATE TABLE `workflow_tracker` (
  `reference_id` varchar(50) NOT NULL DEFAULT '',
  `workflow_id` varchar(200) NOT NULL,
  `prev_group_id` bigint(20) DEFAULT NULL,
  `current_group_id` bigint(20) DEFAULT NULL,
  `is_completed` tinyint(1) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  `channel` varchar(50) NOT NULL DEFAULT '',
  `notify_first_approval` tinyint(1) DEFAULT 0,
  `created_by` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `last_modified_date` datetime NOT NULL,
  `extra_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_params`)),
  PRIMARY KEY (`reference_id`,`workflow_id`),
  KEY `WORKFLOW_ID_FK_2` (`workflow_id`),
  KEY `FKrxi6781g7mup6vg7w3c3n7hfp` (`current_group_id`),
  KEY `FKkw690vrv5yhof7j9cn4mgeoyf` (`prev_group_id`),
  CONSTRAINT `FKkw690vrv5yhof7j9cn4mgeoyf` FOREIGN KEY (`prev_group_id`) REFERENCES `group` (`group_id`),
  CONSTRAINT `FKrxi6781g7mup6vg7w3c3n7hfp` FOREIGN KEY (`current_group_id`) REFERENCES `group` (`group_id`),
  CONSTRAINT `WORKFLOW_ID_FK_2` FOREIGN KEY (`workflow_id`) REFERENCES `workflow` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `keys_mapping` (
  `key_id` int(11) NOT NULL AUTO_INCREMENT,
  `key_name` varchar(255) NOT NULL,
PRIMARY KEY (`key_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `group_properties` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL,
  `key_id` int(11) NOT NULL,
  `value_type` tinyint(1) NOT NULL,
  `value_int` int(11) DEFAULT NULL,
  `value_text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id_key` (`group_id`,`key_id`),
  KEY `group_id_fk` (`group_id`),
  KEY `key_id_fk` (`key_id`),
  CONSTRAINT `group_id_fk` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `key_id_fk` FOREIGN KEY (`key_id`) REFERENCES `keys_mapping` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `group_admin_properties` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL,
  `admin_id` bigint(20) NOT NULL,
  `key_id` int(11) NOT NULL,
  `value_type` tinyint(1) NOT NULL,
  `value_int` int(11) DEFAULT NULL,
  `value_text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_admin_key` (`group_id`,`admin_id`,`key_id`),
  KEY `group_admin_fk` (`group_id`,`admin_id`),
  KEY `key_id_gap_fk` (`key_id`),
  CONSTRAINT `group_admin_fk` FOREIGN KEY (`group_id`, `admin_id`) REFERENCES `group_admin` (`group_id`, `admin_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `key_id_gap_fk` FOREIGN KEY (`key_id`) REFERENCES `keys_mapping` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;